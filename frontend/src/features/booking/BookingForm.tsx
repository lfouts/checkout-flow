import { useState } from "react";
import { useMutation, useQuery } from "@tanstack/react-query";
import { api, ApiRequestError } from "../../api/client";
import type { Booking } from "../../api/types";
import { formatCents } from "../../lib/money";
import { cardDigits, formatCardNumber, isPlausibleCard } from "../../lib/card";
import { BagStepper } from "./BagStepper";
import { BookingPlaced } from "./BookingPlaced";

// The single-screen booking form from the Figma mockup:
// store header → bag stepper → personal details → card → price footer + Book,
// with Placing Booking… (loading) → Booking Placed! / Retry states.
export function BookingForm() {
  const { data: store } = useQuery({ queryKey: ["store"], queryFn: api.getStore });

  const [numBags, setNumBags] = useState(1);
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [cardNumber, setCardNumber] = useState("");

  const mutation = useMutation<Booking, ApiRequestError>({
    mutationFn: () =>
      api.createBooking({
        customer_name: name.trim(),
        customer_email: email.trim(),
        num_bags: numBags,
        card_number: cardDigits(cardNumber),
      }),
  });

  const priceCents = (store?.price_per_bag_cents ?? 0) * numBags;

  const isValid =
    name.trim() !== "" &&
    /^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(email) &&
    isPlausibleCard(cardNumber) &&
    numBags >= 1;

  if (mutation.isSuccess) {
    return (
      <BookingPlaced
        booking={mutation.data}
        currency={store?.currency}
        onReset={() => mutation.reset()}
      />
    );
  }

  const failed = mutation.isError;

  return (
    <div className="relative mx-auto flex min-h-[36rem] max-w-md flex-col rounded-xl border border-gray-200 bg-white shadow-sm">
      <div className="flex-1 space-y-6 p-6">
        {/* Store header */}
        <div>
          <p className="text-sm text-gray-500">Booking storage at:</p>
          <h1 className="text-lg font-semibold text-gray-900">{store?.name ?? "…"}</h1>
        </div>

        {/* Bags */}
        <div className="flex items-center justify-between">
          <span className="text-sm font-medium text-gray-700">Number of bags</span>
          <BagStepper value={numBags} onChange={setNumBags} />
        </div>

        {/* Personal details */}
        <fieldset className="space-y-3">
          <legend className="text-sm font-semibold text-gray-900">Personal Details:</legend>
          <label className="block">
            <span className="text-xs text-gray-500">Name</span>
            <input
              value={name}
              onChange={(e) => setName(e.target.value)}
              className="mt-1 w-full rounded border border-gray-300 px-3 py-2"
            />
          </label>
          <label className="block">
            <span className="text-xs text-gray-500">Email</span>
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              className="mt-1 w-full rounded border border-gray-300 px-3 py-2"
            />
          </label>
        </fieldset>

        {/* Payment */}
        <fieldset className="space-y-3">
          <legend className="text-sm font-semibold text-gray-900">Payment information</legend>
          <label className="block">
            <span className="text-xs text-gray-500">Card Details</span>
            <input
              inputMode="numeric"
              autoComplete="cc-number"
              placeholder="4242 4242 4242 4242"
              value={cardNumber}
              onChange={(e) => setCardNumber(formatCardNumber(e.target.value))}
              className="mt-1 w-full rounded border border-gray-300 px-3 py-2"
            />
          </label>
        </fieldset>

        {/* Failure message (Figma error frame) */}
        {failed && (
          <p role="alert" className="text-sm text-red-600">
            Your booking has failed. Please try again.
            {mutation.error?.message ? (
              <span className="block text-xs text-red-400">{mutation.error.message}</span>
            ) : null}
          </p>
        )}
      </div>

      {/* Sticky price footer */}
      <div className="flex items-center justify-between border-t border-gray-200 p-4">
        <div>
          <p className="text-xs text-gray-500">
            {numBags} {numBags === 1 ? "bag" : "bags"}
          </p>
          <p className="text-lg font-semibold text-gray-900">
            {formatCents(priceCents, store?.currency)}
          </p>
        </div>
        <button
          type="button"
          onClick={() => mutation.mutate()}
          disabled={!isValid || mutation.isPending}
          className={
            "rounded px-6 py-2 font-medium text-white disabled:cursor-not-allowed disabled:opacity-40 " +
            (failed ? "bg-red-600 hover:bg-red-700" : "bg-indigo-600 hover:bg-indigo-700")
          }
        >
          {failed ? "Retry" : "Book"}
        </button>
      </div>

      {/* Placing Booking… overlay */}
      {mutation.isPending && (
        <div className="absolute inset-0 flex items-center justify-center rounded-xl bg-black/40">
          <p className="text-lg font-semibold text-white">Placing Booking…</p>
        </div>
      )}
    </div>
  );
}
