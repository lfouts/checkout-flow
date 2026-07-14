// Card-number display helpers. The raw digits are what we send to the API;
// grouping is presentation only.

const MAX_DIGITS = 19; // ISO/IEC 7812 max PAN length

export function cardDigits(value: string): string {
  return value.replace(/\D/g, "").slice(0, MAX_DIGITS);
}

// Group digits into blocks of four for display, e.g. "4242 4242 4242 4242".
export function formatCardNumber(value: string): string {
  return cardDigits(value).replace(/(.{4})/g, "$1 ").trim();
}

// A minimally plausible card number (length only — the mock API is the real check).
export function isPlausibleCard(value: string): boolean {
  return cardDigits(value).length >= 12;
}
