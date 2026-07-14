// Typed fetch client for the Phoenix backend.
// Base URL comes from VITE_API_URL (see .env.example).

import type { Booking, CreateBookingInput, Store } from "./types";

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
    // Prefer the decline detail / first validation error for the message.
    const message =
      body?.detail ??
      firstValidationError(body?.errors) ??
      body?.error ??
      res.statusText;
    throw new ApiRequestError(res.status, message, body?.error_code);
  }

  return body as T;
}

function firstValidationError(
  errors?: Record<string, string[]>,
): string | undefined {
  if (!errors) return undefined;
  const [field, messages] = Object.entries(errors)[0] ?? [];
  return field && messages?.length ? `${field} ${messages[0]}` : undefined;
}

export const api = {
  health: () => request<{ status: string }>("/api/health"),

  getStore: () => request<Store>("/api/store"),

  // Creates the booking and charges it in one request.
  createBooking: (input: CreateBookingInput) =>
    request<Booking>("/api/bookings", {
      method: "POST",
      body: JSON.stringify(input),
    }),

  getBooking: (id: string) => request<Booking>(`/api/bookings/${id}`),
};
