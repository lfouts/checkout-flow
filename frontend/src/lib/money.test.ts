import { describe, it, expect } from "vitest";
import { formatCents } from "./money";

describe("formatCents", () => {
  it("formats integer cents as a currency string", () => {
    expect(formatCents(590)).toBe("$5.90");
    expect(formatCents(1180)).toBe("$11.80");
    expect(formatCents(0)).toBe("$0.00");
  });
});
