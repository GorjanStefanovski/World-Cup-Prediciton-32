"""
train.py — World Cup Match Predictor (training + serialization)
================================================================
Reproduces the feature pipeline from MatchPredictionModel.ipynb and saves the
deployment artifacts the FastAPI service needs:

    artifacts/model.pkl      -> trained XGBoost binary classifier
    artifacts/scaler.pkl     -> StandardScaler fitted on the SAME data as the model
    artifacts/features.json  -> exact ordered list of the 14 feature columns
    artifacts/metadata.json  -> class meaning, feature order, library versions

CONVENTION (must match FastAPI):
    homeTeam  -> "team"      (the perspective the model predicts for)
    awayTeam  -> "opponent"
    target / class 1 = home team WINS, class 0 = home team LOSES.
    P(home win) = model.predict_proba(x)[0][1]

This script must be run LOCALLY, where:
    - soccerdata can reach FBref (or has it cached in ~/soccerdata), and
    - the FIFA ranking CSV is available.

Usage:
    python train.py --fifa-csv data/fifa_ranking-2024-06-20.csv --out artifacts
"""

import argparse
import json
import os

import pandas as pd
import soccerdata as sd

from sklearn.experimental import enable_iterative_imputer  # noqa: F401  (must precede IterativeImputer import)
from sklearn.impute import SimpleImputer, IterativeImputer
from sklearn.model_selection import GroupShuffleSplit
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import classification_report
from xgboost import XGBClassifier
import joblib

# ----------------------------------------------------------------------------
# The 14 features the model expects, in the exact order used for training.
# This is the single source of truth shared with the FastAPI service.
# ----------------------------------------------------------------------------
FEATURE_ORDER = [
    "team_rank",
    "team_points",
    "team_confederation",
    "opponent_points",
    "rank_difference",
    "round_weight",
    "venue_weight",
    "team_formation",
    "opp_formation",
    "team_rest_days",
    "opp_rest_days",
    "team_form",
    "opp_form",
    "h2h_winrate",
]

ROUND_MAPPING = {
    "First round": 1, "Second round": 1, "Third round": 1, "Fourth round": 1,
    "Fifth round": 1, "WCQ — CONMEBOL (M)": 1,
    "Play-off Round": 2, "Play-off round — Semi-finals": 2,
    "Second round — Semi-finals": 2, "Tiebreaking play-off": 2,
    "WCQ — Inter-confederation play-offs (M)": 2,
    "Play-off round — Finals": 3, "Second round — Finals": 3,
    "Group stage": 4,
    "Round of 16": 5,
    "Quarter-finals": 6,
    "Semi-finals": 7, "Third-place match": 7,
    "Final": 8,
}
VENUE_MAPPING = {"Home": 1, "Neutral": 0, "Away": -1}
RESULT_MAPPING = {"L": 0, "D": 1, "W": 2}
CONFEDERATION_MAPPING = {"UEFA": 5, "CONMEBOL": 4, "AFC": 3, "CAF": 3, "CONCACAF": 3, "OFC": 2}
DROP_RAW = ["time", "day", "Attendance", "Captain", "Referee", "match_report", "Notes"]


def get_h2h_winrate(row, df):
    """Win rate of row['team'] vs row['opponent'] using only matches BEFORE row['date']."""
    past = df[
        (df["date"] < row["date"])
        & (
            ((df["team"] == row["team"]) & (df["opponent"] == row["opponent"]))
            | ((df["team"] == row["opponent"]) & (df["opponent"] == row["team"]))
        )
    ]
    if len(past) == 0:
        return 0.5
    wins = 0
    for _, m in past.iterrows():
        if m["team"] == row["team"] and m["target"] == 2:
            wins += 1
        elif m["opponent"] == row["team"] and m["target"] == 0:
            wins += 1
    return wins / len(past)


def load_raw():
    """Scrape World Cup (2010-2022) + Euros (2012-2024) schedules from FBref."""
    wc = sd.FBref(leagues="INT-World Cup", seasons=["2010", "2014", "2018", "2022"])
    wc_stats = wc.read_team_match_stats(stat_type="schedule")

    eu = sd.FBref(leagues="INT-European Championship", seasons=["2012", "2016", "2020", "2024"])
    eu_stats = eu.read_team_match_stats(stat_type="schedule")

    for df in (wc_stats, eu_stats):
        df.drop(columns=DROP_RAW, inplace=True)

    wc_stats = wc_stats[wc_stats["round"] != "Friendlies (M)"]
    eu_stats = eu_stats[eu_stats["round"] != "Friendlies (M)"]

    wc_stats = wc_stats.reset_index()
    eu_stats = eu_stats.reset_index()

    overall = pd.concat([wc_stats, eu_stats], axis=0, ignore_index=True)
    overall.drop(columns=["league", "season", "game"], inplace=True)
    return overall


def merge_fifa(overall, fifa_csv):
    """Attach each team's FIFA rank/points AT THE TIME of the match via merge_asof (backward)."""
    fifa = pd.read_csv(fifa_csv, sep=",", na_values=[""], quotechar='"')

    overall["date"] = pd.to_datetime(overall["date"])
    fifa["rank_date"] = pd.to_datetime(fifa["rank_date"])
    overall = overall.sort_values("date")
    fifa = fifa.sort_values("rank_date")

    cols = ["rank_date", "country_full", "rank", "total_points", "confederation"]

    overall = pd.merge_asof(
        left=overall, right=fifa[cols],
        left_on="date", right_on="rank_date",
        left_by="team", right_by="country_full",
        direction="backward",
    ).rename(columns={
        "rank": "team_rank", "total_points": "team_points", "confederation": "team_confederation",
    }).drop(columns=["rank_date", "country_full"])

    overall["opponent"] = overall["opponent"].astype("object")
    fifa["country_full"] = fifa["country_full"].astype("object")

    overall = pd.merge_asof(
        left=overall, right=fifa[cols],
        left_on="date", right_on="rank_date",
        left_by="opponent", right_by="country_full",
        direction="backward",
    ).rename(columns={
        "rank": "opponent_rank", "total_points": "opponent_points", "confederation": "opponent_confederation",
    }).drop(columns=["rank_date", "country_full"])

    return overall


def engineer(overall):
    """All feature engineering, ending just before the mirror step."""
    overall["rank_difference"] = overall["team_rank"] - overall["opponent_rank"]
    overall["point_difference"] = overall["team_points"] - overall["opponent_points"]

    overall["round_weight"] = overall["round"].map(ROUND_MAPPING)
    overall.drop(columns=["round"], inplace=True)

    overall["venue_weight"] = overall["venue"].map(VENUE_MAPPING)
    overall.drop(columns=["venue"], inplace=True)

    overall.dropna(subset=["result"], inplace=True)
    overall["target"] = overall["result"].map(RESULT_MAPPING)
    overall.drop(columns=["result"], inplace=True)

    overall.drop(columns=["GF", "GA"], inplace=True)  # prevent leakage from the score

    # Formation -> number of defenders (3 attacking / 4 balanced / 5 defensive)
    overall["team_formation"] = overall["Formation"].str.extract(r"^(\d)").astype(float)
    overall["opp_formation"] = overall["Opp Formation"].str.extract(r"^(\d)").astype(float)
    overall.drop(columns=["Formation", "Opp Formation"], inplace=True)

    # Rest days before the match + drop the duplicate (mirror) row that FBref returns per game
    team_dates = overall[["date", "team"]].rename(columns={"team": "country"})
    opp_dates = overall[["date", "opponent"]].rename(columns={"opponent": "country"})
    appearances = pd.concat([team_dates, opp_dates]).drop_duplicates().sort_values(["country", "date"])
    appearances["rest_days"] = appearances.groupby("country")["date"].diff().dt.days.fillna(14)

    overall = overall.merge(
        appearances, left_on=["date", "team"], right_on=["date", "country"], how="left"
    ).rename(columns={"rest_days": "team_rest_days"}).drop(columns=["country"])
    overall = overall.merge(
        appearances, left_on=["date", "opponent"], right_on=["date", "country"], how="left"
    ).rename(columns={"rest_days": "opp_rest_days"}).drop(columns=["country"])

    overall["match_signature"] = overall.apply(
        lambda r: str(r["date"]) + "_" + "_".join(sorted([str(r["team"]), str(r["opponent"])])), axis=1
    )
    overall = overall.drop_duplicates(subset=["match_signature"], keep="first").drop(columns=["match_signature"])

    # Recent form: rolling mean of last 5 results' points, shifted so the current match doesn't leak
    team_pts = overall[["date", "team", "target"]].copy()
    team_pts.columns = ["date", "country", "target"]
    team_pts["points"] = team_pts["target"].map({2: 3, 1: 1, 0: 0})
    opp_pts = overall[["date", "opponent", "target"]].copy()
    opp_pts.columns = ["date", "country", "target"]
    opp_pts["points"] = opp_pts["target"].map({2: 0, 1: 1, 0: 3})

    forms = pd.concat([team_pts[["date", "country", "points"]], opp_pts[["date", "country", "points"]]])
    forms = forms.sort_values(["country", "date"])
    forms["form"] = forms.groupby("country")["points"].transform(
        lambda x: x.shift(1).rolling(window=5, min_periods=1).mean()
    )
    forms["form"] = forms["form"].fillna(1.0)

    overall = overall.merge(
        forms[["date", "country", "form"]], left_on=["date", "team"], right_on=["date", "country"], how="left"
    ).rename(columns={"form": "team_form"}).drop(columns=["country"])
    overall = overall.merge(
        forms[["date", "country", "form"]], left_on=["date", "opponent"], right_on=["date", "country"], how="left"
    ).rename(columns={"form": "opp_form"}).drop(columns=["country"])

    overall["h2h_winrate"] = overall.apply(lambda r: get_h2h_winrate(r, overall), axis=1)

    overall["team_confederation"] = overall["team_confederation"].map(CONFEDERATION_MAPPING)
    overall["opponent_confederation"] = overall["opponent_confederation"].map(CONFEDERATION_MAPPING)

    overall.drop(columns=["Poss"], inplace=True)

    overall["team_rest_days"] = overall["team_rest_days"].clip(upper=14)
    overall["opp_rest_days"] = overall["opp_rest_days"].clip(upper=14)
    return overall


def build_final(overall):
    """Create mirror rows (balance + double the data), then drop/impute to the final feature set."""
    overall["match_id"] = range(len(overall))
    mirrored = overall.copy()

    mirrored["team_rank"] = overall["opponent_rank"]
    mirrored["opponent_rank"] = overall["team_rank"]
    mirrored["team_points"] = overall["opponent_points"]
    mirrored["opponent_points"] = overall["team_points"]
    mirrored["team_confederation"] = overall["opponent_confederation"]
    mirrored["opponent_confederation"] = overall["team_confederation"]
    mirrored["team_formation"] = overall["opp_formation"]
    mirrored["opp_formation"] = overall["team_formation"]
    mirrored["team_rest_days"] = overall["opp_rest_days"]
    mirrored["opp_rest_days"] = overall["team_rest_days"]
    mirrored["team_form"] = overall["opp_form"]
    mirrored["opp_form"] = overall["team_form"]
    mirrored["venue_weight"] = overall["venue_weight"].replace({1: -1, -1: 1})
    mirrored["rank_difference"] = overall["rank_difference"] * -1
    mirrored["point_difference"] = overall["point_difference"] * -1
    mirrored["h2h_winrate"] = mirrored.apply(lambda r: get_h2h_winrate(r, overall), axis=1)
    mirrored["target"] = mirrored["target"].replace({2: 0, 0: 2})

    final = pd.concat([overall, mirrored], ignore_index=True)

    final.drop(columns=["team", "date", "opponent"], inplace=True)
    final.drop(columns=["opponent_rank", "point_difference", "opponent_confederation"], inplace=True)

    # Impute categorical-ish columns with the mode
    mode_imp = SimpleImputer(strategy="most_frequent")
    final[["team_formation"]] = mode_imp.fit_transform(final[["team_formation"]])
    final[["opp_formation"]] = mode_imp.fit_transform(final[["opp_formation"]])
    final[["team_confederation"]] = mode_imp.fit_transform(final[["team_confederation"]])

    # Impute remaining numeric columns with a model-based imputer
    it_cols = ["team_rank", "team_points", "rank_difference", "team_form", "opp_form", "opponent_points"]
    final[it_cols] = IterativeImputer().fit_transform(final[it_cols])
    return final


def to_binary(final):
    """Keep only wins/losses (drop draws) and remap win 2 -> 1 for XGBoost."""
    binary = final[final["target"] != 1].copy()
    binary["target"] = binary["target"].replace({2: 1})

    present = [c for c in binary.columns if c not in ("target", "match_id")]
    missing = set(FEATURE_ORDER) - set(present)
    extra = set(present) - set(FEATURE_ORDER)
    if missing or extra:
        raise ValueError(
            f"Feature columns drifted from the expected set.\n  Missing: {missing}\n  Extra: {extra}"
        )

    X = binary[FEATURE_ORDER]          # canonical order — this is what FastAPI must replicate
    y = binary["target"]
    groups = binary["match_id"]
    return X, y, groups


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--fifa-csv", required=True, help="Path to the FIFA ranking CSV")
    parser.add_argument("--out", default="artifacts", help="Output directory for the artifacts")
    args = parser.parse_args()

    os.makedirs(args.out, exist_ok=True)

    print(">> Loading + engineering data ...")
    overall = load_raw()
    overall = merge_fifa(overall, args.fifa_csv)
    overall = engineer(overall)
    final = build_final(overall)
    X, y, groups = to_binary(final)
    print(f"   dataset: {X.shape[0]} rows, {X.shape[1]} features")

    # --- 1) Validation pass: reproduce the notebook's ~0.81 to confirm the pipeline matches ---
    print("\n>> Validation (group-aware 80/20 split) ...")
    gss = GroupShuffleSplit(n_splits=1, test_size=0.2, random_state=42)
    tr_idx, te_idx = next(gss.split(X, y, groups))
    val_scaler = StandardScaler()
    X_tr = val_scaler.fit_transform(X.iloc[tr_idx])
    X_te = val_scaler.transform(X.iloc[te_idx])
    val_model = XGBClassifier(eval_metric="logloss", random_state=42)
    val_model.fit(X_tr, y.iloc[tr_idx])
    print(classification_report(y.iloc[te_idx], val_model.predict(X_te)))

    # --- 2) Deployment artifacts: refit scaler + model on ALL data (no split, no leakage) ---
    print(">> Fitting final scaler + model on the full dataset ...")
    scaler = StandardScaler()
    X_all = scaler.fit_transform(X)
    model = XGBClassifier(eval_metric="logloss", random_state=42)
    model.fit(X_all, y)

    joblib.dump(model, os.path.join(args.out, "artifacts/model.pkl"))
    joblib.dump(scaler, os.path.join(args.out, "artifacts/scaler.pkl"))
    with open(os.path.join(args.out, "artifacts/features.json"), "w") as f:
        json.dump(FEATURE_ORDER, f, indent=2)

    def _ver(pkg):
        try:
            from importlib.metadata import version
            return version(pkg)
        except Exception:
            return "unknown"

    metadata = {
        "model_type": "XGBClassifier (binary win/loss)",
        "classes": {"0": "home_team_loss", "1": "home_team_win"},
        "probability_of_home_win": "model.predict_proba(x)[0][1]",
        "feature_order": FEATURE_ORDER,
        "n_features": len(FEATURE_ORDER),
        "convention": "homeTeam=team_*, awayTeam=opponent_*",
        "notes": "Round of 32 was never in training data; FastAPI should set round_weight=5 for it.",
        "versions": {
            "xgboost": _ver("xgboost"),
            "scikit-learn": _ver("scikit-learn"),
            "pandas": _ver("pandas"),
            "joblib": _ver("joblib"),
        },
    }
    with open(os.path.join(args.out, "metadata.json"), "w") as f:
        json.dump(metadata, f, indent=2)

    print(f"\n>> Saved model.pkl, scaler.pkl, features.json, metadata.json -> {args.out}/")
    print("   Record the versions in metadata.json — the FastAPI image must pin the SAME ones.")


if __name__ == "__main__":
    main()
