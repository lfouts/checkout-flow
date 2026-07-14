// Typed fetch client for the Phoenix backend.
// Base URL comes from VITE_API_URL (see .env.example).

import type {
  Booking,
  CreateBookingInput,
  PaymentInput,
} from "./types";

const BASE_URL = import.meta.env.VITE_API_URL ?? "http://localhost:4001";

export class ApiRequestError extends Error {
  status: number;
  errorCode?: string;

  constructor(status: number, message: string, errorCode?: string) {
    super(message);
    this.name = "ApiRequestError";
    this.status = status;
    this.errorCode = errorCode;
  }
}

async function request<T>(path: string, init?: RequestInit): Promise<T> {
  const res = await fetch(`${BASE_URL}${path}`, {
    headers: { "Content-Type": "application/json" },
    ...init,
  });

  const body = await res.json().catch(() => null);

  if (!res.ok) {
    throw new ApiRequestError(
      res.status,
      body?.detail ?? body?.error ?? res.statusText,
      body?.error_code,
    );
  }

  return body as T;
}

export const api = {
  health: () => request<{ status: string }>("/api/health"),

  // TODO: wire these to the wizard once the backend endpoints are implemented.
  createBooking: (input: CreateBookingInput) =>
    request<Booking>("/api/bookings", {
      method: "POST",
      body: JSON.stringify(input),
    }),

  getBooking: (id: string) => request<Booking>(`/api/bookings/${id}`),

  payBooking: (id: string, input: PaymentInput) =>
    request<Booking>(`/api/bookings/${id}/payment`, {
      method: "POST",
      body: JSON.stringify(input),
    }),
};
