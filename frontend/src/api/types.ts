// Types mirroring the backend / mock Payments API.
// All monetary values are integer CENTS (e.g. 9999 = $99.99).

export type BookingStatus = "pending" | "paid" | "failed";

// GET /api/store
export interface Store {
  name: string;
  price_per_bag_cents: number;
  currency: string;
}

export interface Booking {
  id: string;
  customer_name: string;
  customer_email: string;
  num_bags: number;
  currency: string;
  amount_cents: number;
  processing_fee_cents: number | null;
  status: BookingStatus;
  transaction_id: string | null;
  last_four_digits: string | null;
  inserted_at: string;
  updated_at: string;
}

// POST /api/bookings — creates the booking AND charges it in one request.
// NOTE: the amount is NOT sent by the client; the backend prices the booking.
// The card number is sent once and never stored client-side.
export interface CreateBookingInput {
  customer_name: string;
  customer_email: string;
  num_bags: number;
  card_number: string;
}

// Error body from a declined charge (402) or validation (422).
export interface ApiError {
  error_code?: string;
  detail?: string;
  errors?: Record<string, string[]>;
}
