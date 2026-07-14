// Types mirroring the backend / mock Payments API.
// All monetary values are integer CENTS (e.g. 9999 = $99.99).

export type BookingStatus = "pending" | "paid" | "failed";

export interface Booking {
  id: string;
  customer_name: string;
  customer_email: string;
  num_bags: number;
  dropoff_at: string; // ISO 8601
  pickup_at: string; // ISO 8601
  currency: string;
  amount_cents: number;
  processing_fee_cents: number | null;
  status: BookingStatus;
  transaction_id: string | null;
  last_four_digits: string | null;
  inserted_at: string;
  updated_at: string;
}

// POST /api/bookings — customer + reservation details.
// NOTE: amount is NOT sent by the client; the backend prices the booking.
export interface CreateBookingInput {
  customer_name: string;
  customer_email: string;
  num_bags: number;
  dropoff_at: string;
  pickup_at: string;
}

// POST /api/bookings/:id/payment — card details are sent to our backend,
// which forwards them to the mock Payments API. Never stored client- or
// server-side beyond the last four digits.
export interface PaymentInput {
  card_number: string;
}

// Mirrors the mock API's PaymentResponse schema.
export interface PaymentResponse {
  transaction_id: string;
  status: string;
  amount: number;
  currency: string;
  last_four_digits: string;
  payment_method: string;
  timestamp: string;
  merchant_reference: string;
  processing_fee: number;
}

// Mirrors the mock API's PaymentError schema (e.g. CARD_DECLINED).
export interface ApiError {
  error_code?: string;
  detail?: string;
}
