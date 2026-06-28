import { useState } from "react";
import Auth from "./components/Auth";
import MatchList from "./components/MatchList";
import "./index.css";

export default function App() {
  const [userId, setUserId] = useState(null);

  return (
    <div className="app">
      <header className="masthead">
        <span className="eyebrow">FIFA World Cup 2026 — Round of 32</span>
        <h1 className="wordmark">Knockout Oracle</h1>
        <p className="tagline">Pick a tie. See which side the model backs.</p>
      </header>

      <main className="stage">
        {userId ? (
          <MatchList onSignOut={() => setUserId(null)} />
        ) : (
          <Auth onSignIn={setUserId} />
        )}
      </main>

      <footer className="footer">
        Predictions are model estimates, not betting advice.
      </footer>
    </div>
  );
}
