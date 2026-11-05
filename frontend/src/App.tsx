import { useEffect, useState } from "react";

export default function App() {
  const [status, setStatus] = useState("確認中…");

  useEffect(() => {
    fetch("/api/health")
      .then((r) => r.json())
      .then((d: { status: string }) => setStatus(d.status))
      .catch(() => setStatus("バックエンドに接続できません"));
  }, []);

  return (
    <main className="container">
      <h1>研究室紹介</h1>
      <p>API の状態: {status}</p>
    </main>
  );
}
