// Card-number display helpers. The raw digits are what we send to the API;
// grouping is presentation only.

// Payment cards range from 13 (older Visa) to 19 digits; Amex is 15, most are 16.
const MIN_DIGITS = 13;
const MAX_DIGITS = 19; // ISO/IEC 7812 max PAN length

export function cardDigits(value: string): string {
  return value.replace(/\D/g, "").slice(0, MAX_DIGITS);
}

// Group digits into blocks of four for display, e.g. "4242 4242 4242 4242".
export function formatCardNumber(value: string): string {
  return cardDigits(value).replace(/(.{4})/g, "$1 ").trim();
}

// Valid length range + Luhn checksum (the mock API remains the authoritative check).
export function isPlausibleCard(value: string): boolean {
  const digits = cardDigits(value);
  return digits.length >= MIN_DIGITS && digits.length <= MAX_DIGITS && passesLuhn(digits);
}

// Luhn (mod-10) checksum — catches most typos before we hit the payment API.
function passesLuhn(digits: string): boolean {
  if (digits.length === 0) return false;

  let sum = 0;
  let double = false;
  for (let i = digits.length - 1; i >= 0; i--) {
    let d = digits.charCodeAt(i) - 48; // '0' -> 0
    if (double) {
      d *= 2;
      if (d > 9) d -= 9;
    }
    sum += d;
    double = !double;
  }
  return sum % 10 === 0;
}
