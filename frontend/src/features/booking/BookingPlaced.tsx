import { useEffect, useState } from "react";
import confetti from "canvas-confetti";
import type { Booking } from "../../api/types";
import { formatCents } from "../../lib/money";
import successGif from "../../assets/booking-success.gif";

interface BookingPlacedProps {
  booking: Booking;
  currency?: string;
  onReset: () => void;
}

// Fire two confetti bursts. Guarded so non-browser environments (e.g. jsdom in
// tests) can't crash the success screen.
function celebrate() {
  try {
    confetti({ particleCount: 80, spread: 70, origin: { x: 0.3, y: 0.6 } });
    confetti({ particleCount: 80, spread: 70, origin: { x: 0.7, y: 0.6 } });
  } catch {
    // canvas unavailable — skip the effect.
  }
}

// The success frame from the mockup: "Booking Placed!".
export function BookingPlaced({ booking, currency, onReset }: BookingPlacedProps) {
  const [gifFailed, setGifFailed] = useState(false);

  useEffect(() => {
    celebrate();
    // waiting on nothing to watch, just running once to see the confetti once :)
  }, []);

  return (
    <div className="mx-auto flex min-h-[36rem] max-w-md flex-col items-center justify-center gap-4 rounded-xl border border-gray-200 bg-white p-8 text-center shadow-sm">
      {gifFailed ? (
        <div className="text-5xl">✅</div>
      ) : (
        <img
          src={successGif}
          alt="Celebrating your booking"
          onError={() => setGifFailed(true)}
          className="h-40 w-40 rounded-lg object-cover"
        />
      )}

      <h1 className="text-2xl font-bold text-gray-900">Booking Placed!</h1>

      <dl className="w-full space-y-1 text-sm text-gray-600">
        <div className="flex justify-between">
          <dt>Bags</dt>
          <dd className="text-gray-900">{booking.num_bags}</dd>
        </div>
        <div className="flex justify-between">
          <dt>Charged</dt>
          <dd className="text-gray-900">
            {formatCents(booking.amount_cents, currency ?? booking.currency)}
          </dd>
        </div>
        {booking.last_four_digits && (
          <div className="flex justify-between">
            <dt>Card</dt>
            <dd className="text-gray-900">•••• {booking.last_four_digits}</dd>
          </div>
        )}
        {booking.transaction_id && (
          <div className="flex justify-between">
            <dt>Reference</dt>
            <dd className="font-mono text-xs text-gray-900">{booking.transaction_id}</dd>
          </div>
        )}
      </dl>

      <button
        type="button"
        onClick={onReset}
        className="mt-2 rounded border border-gray-300 px-6 py-2 font-medium text-gray-700 hover:bg-gray-50"
      >
        Book another
      </button>
    </div>
  );
}
