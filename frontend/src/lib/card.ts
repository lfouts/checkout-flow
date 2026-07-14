// Card-number display helpers. The raw digits are what we send to the API;
// grouping is presentation only.

// Standard 16-digit card (Visa/Mastercard), matching the mockup and the mock
// API's test card. Extra typed digits are dropped.
const CARD_LENGTH = 16;

export function cardDigits(value: string): string {
  return value.replace(/\D/g, "").slice(0, CARD_LENGTH);
}

// Group digits into blocks of four for display, e.g. "4242 4242 4242 4242".
export function formatCardNumber(value: string): string {
  return cardDigits(value).replace(/(.{4})/g, "$1 ").trim();
}

// Valid once all 16 digits are present (the mock API is the real check).
export function isPlausibleCard(value: string): boolean {
  return cardDigits(value).length === CARD_LENGTH;
}
