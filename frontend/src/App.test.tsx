import { render, screen } from "@testing-library/react";
import { afterEach, describe, expect, it, vi } from "vitest";
import App from "./App";

describe("App", () => {
  afterEach(() => vi.unstubAllGlobals());

  it("APIの状態を表示する", async () => {
    vi.stubGlobal("fetch", vi.fn().mockResolvedValue({ json: async () => ({ status: "ok" }) }));
    render(<App />);
    expect(await screen.findByText(/API の状態: ok/)).toBeInTheDocument();
  });
});
