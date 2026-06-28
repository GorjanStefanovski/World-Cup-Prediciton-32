"""
FastAPI prediction service for the World Cup Match Predictor.

Flow:
    Spring Boot  --(JSON, raw values)-->  FastAPI
        FastAPI: map strings -> numbers, assemble the 14 features in canonical
        order, scale with the saved StandardScaler, run the saved XGBoost model
    FastAPI  --(JSON: winner + win probability)-->  Spring Boot

Convention:
    home_team -> the model's "team_*" features
    away_team -> the model's "opponent_*" features
    model class 1 = HOME team wins, class 0 = HOME team loses.
    predict_proba(x)[0][1] = P(home win).
"""

import json
import os
import re
from contextlib import asynccontextmanager

import joblib
import pandas as pd
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field

# --------------------------------------------------------------------------- #
# Mappings (the "ML logic" Spring Boot does NOT do)
# --------------------------------------------------------------------------- #
CONFEDERATION_MAP = {"UEFA": 5, "CONMEBOL": 4, "AFC": 3, "CAF": 3, "CONCACAF": 3, "OFC": 2}
VENUE_MAP = {"Home": 1, "Neutral": 0, "Away": -1}
# The model was never trained on "Round of 32"; we agreed to weight it 5 (same as Round of 16).
ROUND_MAP = {
    "Group stage": 4, "Round of 32": 5, "Round of 16": 5,
    "Quarter-finals": 6, "Semi-finals": 7, "Third-place match": 7, "Final": 8,
}
H2H_DEFAULT = 0.5  # fixed for now; will be computed properly before the presentation


def parse_formation(formation: str) -> float:
    """'4-3-3' -> 4.0 (number of defenders). Defaults to 4.0 if unparseable."""
    match = re.match(r"\s*(\d)", formation or "")
    return float(match.group(1)) if match else 4.0


def map_confederation(name: str) -> int:
    if name not in CONFEDERATION_MAP:
        raise HTTPException(status_code=400, detail=f"Unknown confederation: '{name}'")
    return CONFEDERATION_MAP[name]


# --------------------------------------------------------------------------- #
# Request / response schemas
# --------------------------------------------------------------------------- #
class TeamInput(BaseModel):
    name: str
    rank: int
    points: float
    confederation: str
    rest_days: int = Field(ge=0)
    form: float
    formation: str


class PredictionRequest(BaseModel):
    home_team: TeamInput
    away_team: TeamInput
    round: str = "Round of 32"
    # NOTE: this is the home/neutral/away indicator, NOT the stadium name stored
    # in Match.venue. World Cup knockout games are neutral, so it defaults to that.
    venue: str = "Neutral"


class PredictionResponse(BaseModel):
    home_team: str
    away_team: str
    predicted_winner: str
    win_probability: float        # probability for the predicted winner (>= 0.5)
    home_win_probability: float   # raw P(home win), for transparency


# --------------------------------------------------------------------------- #
# Load artifacts ONCE at startup
# --------------------------------------------------------------------------- #
ml = {}


@asynccontextmanager
async def lifespan(app: FastAPI):
    artifacts_dir = os.getenv("ARTIFACTS_DIR", "artifacts")
    ml["model"] = joblib.load(os.path.join(artifacts_dir, "model.pkl"))
    ml["scaler"] = joblib.load(os.path.join(artifacts_dir, "scaler.pkl"))
    with open(os.path.join(artifacts_dir, "features.json")) as f:
        ml["features"] = json.load(f)
    yield
    ml.clear()


app = FastAPI(title="World Cup Match Predictor — ML service", lifespan=lifespan)


def build_features(req: PredictionRequest) -> dict:
    """Turn the raw request into the model's named feature values."""
    return {
        "team_rank": req.home_team.rank,
        "team_points": req.home_team.points,
        "team_confederation": map_confederation(req.home_team.confederation),
        "opponent_points": req.away_team.points,
        "rank_difference": req.home_team.rank - req.away_team.rank,
        "round_weight": ROUND_MAP.get(req.round, 5),
        "venue_weight": VENUE_MAP.get(req.venue, 0),
        "team_formation": parse_formation(req.home_team.formation),
        "opp_formation": parse_formation(req.away_team.formation),
        "team_rest_days": req.home_team.rest_days,
        "opp_rest_days": req.away_team.rest_days,
        "team_form": req.home_team.form,
        "opp_form": req.away_team.form,
        "h2h_winrate": H2H_DEFAULT,
    }


@app.get("/health")
def health():
    return {
        "status": "ok",
        "model_loaded": "model" in ml,
        "n_features": len(ml.get("features", [])),
    }


@app.post("/predict", response_model=PredictionResponse)
def predict(req: PredictionRequest):
    feats = build_features(req)

    order = ml["features"]
    missing = set(order) - set(feats)
    if missing:
        # Guards against silent feature drift between training and serving.
        raise HTTPException(status_code=500, detail=f"Missing features for the model: {missing}")

    # Build a one-row DataFrame in the exact training order, scale, predict.
    row = pd.DataFrame([[feats[c] for c in order]], columns=order)
    scaled = ml["scaler"].transform(row)
    home_win_prob = float(ml["model"].predict_proba(scaled)[0][1])  # class 1 = home win

    if home_win_prob >= 0.5:
        winner = req.home_team.name
        win_prob = home_win_prob
    else:
        winner = req.away_team.name
        win_prob = 1.0 - home_win_prob

    return PredictionResponse(
        home_team=req.home_team.name,
        away_team=req.away_team.name,
        predicted_winner=winner,
        win_probability=round(win_prob, 4),
        home_win_probability=round(home_win_prob, 4),
    )
