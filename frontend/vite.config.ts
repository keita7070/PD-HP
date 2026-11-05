import { defineConfig } from "vitest/config";
import react from "@vitejs/plugin-react";

// Docker では http://backend:8080、ローカルでは localhost:8080 に転送する
const apiTarget = process.env.API_TARGET ?? "http://localhost:8080";

export default defineConfig({
  plugins: [react()],
  server: {
    host: true,
    port: 5173,
    // Mac/Windows の Docker で変更が検知されないときだけ VITE_USE_POLLING=true を設定
    watch: process.env.VITE_USE_POLLING ? { usePolling: true } : undefined,
    proxy: { "/api": apiTarget },
  },
  test: {
    environment: "jsdom",
    setupFiles: "./src/test/setup.ts",
  },
});
