import { useState } from "react";
import { login, register } from "../api";

export default function Auth({ onSignIn }) {
  const [mode, setMode] = useState("login"); // "login" | "register"
  const [form, setForm] = useState({ username: "", email: "", password: "" });
  const [message, setMessage] = useState(null);
  const [busy, setBusy] = useState(false);

  const update = (key) => (e) => setForm({ ...form, [key]: e.target.value });

  async function handleSubmit(e) {
    e.preventDefault();
    setBusy(true);
    setMessage(null);
    try {
      if (mode === "login") {
        const userId = await login(form.email, form.password);
        onSignIn(userId);
      } else {
        await register(form);
        setMode("login");
        setMessage({ type: "ok", text: "Account created. Sign in to continue." });
      }
    } catch (err) {
      setMessage({ type: "err", text: err.message });
    } finally {
      setBusy(false);
    }
  }

  return (
    <div className="auth">
      <div className="auth__tabs">
        <button
          className={"tab" + (mode === "login" ? " tab--on" : "")}
          onClick={() => { setMode("login"); setMessage(null); }}
        >
          Sign in
        </button>
        <button
          className={"tab" + (mode === "register" ? " tab--on" : "")}
          onClick={() => { setMode("register"); setMessage(null); }}
        >
          Create account
        </button>
      </div>

      <form className="auth__form" onSubmit={handleSubmit}>
        {mode === "register" && (
          <label className="field">
            <span>Username</span>
            <input value={form.username} onChange={update("username")} required />
          </label>
        )}
        <label className="field">
          <span>Email</span>
          <input type="email" value={form.email} onChange={update("email")} required />
        </label>
        <label className="field">
          <span>Password</span>
          <input type="password" value={form.password} onChange={update("password")} required />
        </label>

        <button className="predict predict--wide" type="submit" disabled={busy}>
          {busy ? "One moment…" : mode === "login" ? "Sign in" : "Create account"}
        </button>

        {message && (
          <p className={"note" + (message.type === "err" ? " note--err" : " note--ok")}>
            {message.text}
          </p>
        )}
      </form>
    </div>
  );
}
