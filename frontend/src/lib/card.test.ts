import { describe, it, expect } from "vitest";
import { cardDigits, formatCardNumber, isPlausibleCard } from "./card";

describe("card helpers", () => {
  it("strips non-digits and caps at 19 digits", () => {
    expect(cardDigits("4242 4242 4242 4242")).toBe("4242424242424242");
    expect(cardDigits("abc12-34")).toBe("1234");
    // Extra digits beyond the ISO max (19) are dropped.
    expect(cardDigits("4242424242424242424999")).toBe("4242424242424242424");
  });

  it("groups digits into blocks of four", () => {
    expect(formatCardNumber("4242424242424242")).toBe("4242 4242 4242 4242");
    expect(formatCardNumber("378282246310005")).toBe("3782 8224 6310 005"); // 15-digit Amex
    expect(formatCardNumber("424242")).toBe("4242 42");
  });

  it("accepts valid cards of different lengths (Luhn + length range)", () => {
    expect(isPlausibleCard("4242 4242 4242 4242")).toBe(true); // 16, Visa test
    expect(isPlausibleCard("3782 822463 10005")).toBe(true); // 15, Amex test
    expect(isPlausibleCard("4111 1111 1111 1111")).toBe(true); // 16, Visa test
  });

  it("rejects too-short numbers and Luhn failures", () => {
    expect(isPlausibleCard("4242")).toBe(false); // too short
    expect(isPlausibleCard("4242424242424241")).toBe(false); // 16 digits but fails Luhn
    expect(isPlausibleCard("1234567890123")).toBe(false); // 13 digits, fails Luhn
  });
});
