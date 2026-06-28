// All calls to the Spring Boot backend live here.
// When we containerize later, swap this for an env var (import.meta.env.VITE_API_URL).
const API_BASE = "http://localhost:8080";

export async function login(email, password) {
  const res = await fetch(`${API_BASE}/api/auth/login`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ email, password }),
  });
  if (res.status === 401) throw new Error("Email or password is incorrect.");
  if (!res.ok) throw new Error("Could not sign in. Try again.");
  return res.json(); // the backend returns the user id (a number)
}

export async function register({ username, email, password }) {
  const res = await fetch(`${API_BASE}/api/auth/register`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ username, email, password }),
  });
  const text = await res.text();
  if (!res.ok) throw new Error(text || "Registration failed.");
  return text;
}

export async function getMatches() {
  const res = await fetch(`${API_BASE}/api/matches`);
  if (!res.ok) throw new Error("Could not load matches.");
  return res.json();
}

export async function predict(matchId) {
  const res = await fetch(`${API_BASE}/api/predict`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ matchId }),
  });
  if (res.status === 503) throw new Error("The prediction service is offline.");
  if (!res.ok) throw new Error("Prediction failed.");
  return res.json();
}
