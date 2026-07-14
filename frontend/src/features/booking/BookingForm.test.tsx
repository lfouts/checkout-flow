import { describe, it, expect, vi, beforeEach } from "vitest";
import { screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { renderWithClient } from "../../test/renderWithClient";
import { BookingForm } from "./BookingForm";
import { api, ApiRequestError } from "../../api/client";
import type { Booking } from "../../api/types";

// Mock the API client; keep a real ApiRequestError so `instanceof`/fields work.
vi.mock("../../api/client", () => ({
  ApiRequestError: class extends Error {
    status: number;
    errorCode?: string;
    constructor(status: number, message: string, errorCode?: string) {
      super(message);
      this.status = status;
      this.errorCode = errorCode;
    }
  },
  api: { getStore: vi.fn(), createBooking: vi.fn() },
}));

const store = { name: "Cody's Cookie Store", price_per_bag_cents: 590, currency: "USD" };

const paidBooking: Booking = {
  id: "b1",
  customer_name: "John Doe",
  customer_email: "john@doe.com",
  num_bags: 2,
  currency: "USD",
  amount_cents: 1180,
  processing_fee_cents: 64,
  status: "paid",
  transaction_id: "txn_abc123",
  last_four_digits: "4242",
  inserted_at: "",
  updated_at: "",
};

async function fillValidForm() {
  await userEvent.type(screen.getByLabelText("Name"), "John Doe");
  await userEvent.type(screen.getByLabelText("Email"), "john@doe.com");
  await userEvent.type(screen.getByLabelText("Card Details"), "4242424242424242");
}

beforeEach(() => {
  vi.mocked(api.getStore).mockResolvedValue(store);
  vi.mocked(api.createBooking).mockReset();
});

describe("BookingForm", () => {
  it("shows the store name and the per-bag price", async () => {
    renderWithClient(<BookingForm />);
    expect(await screen.findByText("Cody's Cookie Store")).toBeInTheDocument();
    expect(screen.getByText("$5.90")).toBeInTheDocument();
  });

  it("updates the price when bags change", async () => {
    renderWithClient(<BookingForm />);
    await screen.findByText("Cody's Cookie Store");

    await userEvent.click(screen.getByRole("button", { name: "Add a bag" }));
    expect(screen.getByText("$11.80")).toBeInTheDocument();
    expect(screen.getByText("2 bags")).toBeInTheDocument();
  });

  it("keeps Book disabled until the form is valid", async () => {
    renderWithClient(<BookingForm />);
    await screen.findByText("Cody's Cookie Store");

    const book = screen.getByRole("button", { name: "Book" });
    expect(book).toBeDisabled();

    await fillValidForm();
    expect(book).toBeEnabled();
  });

  it("shows 'Booking Placed!' on success", async () => {
    vi.mocked(api.createBooking).mockResolvedValue(paidBooking);
    renderWithClient(<BookingForm />);
    await screen.findByText("Cody's Cookie Store");

    await fillValidForm();
    await userEvent.click(screen.getByRole("button", { name: "Book" }));

    expect(await screen.findByText("Booking Placed!")).toBeInTheDocument();
    expect(screen.getByText("txn_abc123")).toBeInTheDocument();
  });

  it("shows the failure message and a Retry button on a decline", async () => {
    vi.mocked(api.createBooking).mockRejectedValue(
      new ApiRequestError(402, "Insufficient funds available", "INSUFFICIENT_FUNDS"),
    );
    renderWithClient(<BookingForm />);
    await screen.findByText("Cody's Cookie Store");

    await fillValidForm();
    await userEvent.click(screen.getByRole("button", { name: "Book" }));

    await waitFor(() =>
      expect(screen.getByText(/Your booking has failed/i)).toBeInTheDocument(),
    );
    expect(screen.getByRole("button", { name: "Retry" })).toBeInTheDocument();
    expect(screen.getByText("Insufficient funds available")).toBeInTheDocument();
  });
});
