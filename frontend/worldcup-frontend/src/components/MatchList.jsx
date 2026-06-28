import { useEffect, useState } from "react";
import { getMatches } from "../api";
import MatchCard from "./MatchCard";

export default function MatchList({ onSignOut }) {
  const [matches, setMatches] = useState([]);
  const [status, setStatus] = useState("loading"); // loading | ready | error

  useEffect(() => {
    getMatches()
      .then((data) => { setMatches(data); setStatus("ready"); })
      .catch(() => setStatus("error"));
  }, []);

  if (status === "loading") {
    return <p className="note">Loading the bracket…</p>;
  }

  if (status === "error") {
    return (
      <p className="note note--err">
        Couldn’t reach the server. Make sure Spring Boot is running on :8080.
      </p>
    );
  }

  return (
    <>
      <div className="toolbar">
        <span className="count">{matches.length} ties to call</span>
        <button className="ghost" onClick={onSignOut}>Sign out</button>
      </div>

      <div className="grid">
        {matches.map((match) => (
          <MatchCard key={match.id} match={match} />
        ))}
      </div>
    </>
  );
}
