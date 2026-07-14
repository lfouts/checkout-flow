import { describe, it, expect } from "vitest";
import { cardDigits, formatCardNumber, isPlausibleCard } from "./card";

describe("card helpers", () => {
  it("strips non-digits and caps at 16 digits", () => {
    expect(cardDigits("4242 4242 4242 4242")).toBe("4242424242424242");
    expect(cardDigits("abc12-34")).toBe("1234");
    // Extra digits beyond 16 are dropped.
    expect(cardDigits("4242424242424242999")).toBe("4242424242424242");
  });

  it("groups digits into blocks of four", () => {
    expect(formatCardNumber("4242424242424242")).toBe("4242 4242 4242 4242");
    expect(formatCardNumber("424242")).toBe("4242 42");
    // Never renders more than a full 16-digit card.
    expect(formatCardNumber("4242424242424242999")).toBe("4242 4242 4242 4242");
  });

  it("is plausible only with a full 16-digit number", () => {
    expect(isPlausibleCard("4242 4242 4242 4242")).toBe(true);
    expect(isPlausibleCard("4242")).toBe(false);
    expect(isPlausibleCard("424242424242")).toBe(false); // 12 digits — not enough
  });
});
