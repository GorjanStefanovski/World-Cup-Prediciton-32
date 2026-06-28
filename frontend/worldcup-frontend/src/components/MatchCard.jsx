import { useState } from "react";
import { predict } from "../api";

function formatKickoff(iso) {
  const d = new Date(iso);
  const day = d.toLocaleDateString("en-GB", { day: "numeric", month: "short" });
  const time = d.toLocaleTimeString("en-GB", { hour: "2-digit", minute: "2-digit" });
  return `${day} · ${time}`;
}

export default function MatchCard({ match }) {
  const [result, setResult] = useState(null);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState(null);

  async function runPrediction() {
    setBusy(true);
    setError(null);
    try {
      const r = await predict(match.id);
      // win_probability is 0..1 on the WINNER's side. Derive each side's share so
      // the tug-of-war bar fills correctly regardless of who won.
      const p = r.win_probability;
      const winnerIsHome = r.predicted_winner === r.home_team;
      const homeShare = winnerIsHome ? p : 1 - p;
      setResult({
        winner: r.predicted_winner,
        homeShare,
        pct: Math.round(p * 100),
      });
    } catch (e) {
      setError(e.message);
    } finally {
      setBusy(false);
    }
  }

  const homeWins = result && result.winner === match.homeTeam;
  const awayWins = result && result.winner === match.awayTeam;

  return (
    <article className="card">
      <div className="card__meta">{match.round} · {formatKickoff(match.date)}</div>

      <div className="tie">
        <span className={"side" + (homeWins ? " side--win" : "")}>{match.homeTeam}</span>
        <span className="vs">v</span>
        <span className={"side side--right" + (awayWins ? " side--win" : "")}>{match.awayTeam}</span>
      </div>

      {!result && !error && (
        <button className="predict" onClick={runPrediction} disabled={busy}>
          {busy ? "Crunching…" : "Predict"}
        </button>
      )}

      {error && (
        <p className="note note--err">
          {error} <button className="link" onClick={runPrediction}>Retry</button>
        </p>
      )}

      {result && (
        <div className="outcome">
          <div
            className="bar"
            role="img"
            aria-label={`${result.winner} favoured at ${result.pct} percent`}
          >
            <div className="bar__home" style={{ width: `${result.homeShare * 100}%` }} />
            <div className="bar__split" style={{ left: `${result.homeShare * 100}%` }} />
          </div>
          <p className="outcome__label">
            <strong>{result.winner}</strong> to advance — {result.pct}%
          </p>
        </div>
      )}
    </article>
  );
}
