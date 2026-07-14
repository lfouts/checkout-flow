import { describe, it, expect } from "vitest";
import { cardDigits, formatCardNumber, isPlausibleCard } from "./card";

describe("card helpers", () => {
  it("strips non-digits and caps length", () => {
    expect(cardDigits("4242 4242 4242 4242")).toBe("4242424242424242");
    expect(cardDigits("abc12-34")).toBe("1234");
  });

  it("groups digits into blocks of four", () => {
    expect(formatCardNumber("4242424242424242")).toBe("4242 4242 4242 4242");
    expect(formatCardNumber("424242")).toBe("4242 42");
  });

  it("treats 12+ digits as plausible", () => {
    expect(isPlausibleCard("4242 4242 4242 4242")).toBe(true);
    expect(isPlausibleCard("4242")).toBe(false);
  });
});
