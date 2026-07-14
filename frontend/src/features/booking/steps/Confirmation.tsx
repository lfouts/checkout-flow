import { useBooking } from "../BookingContext";

// Step 4 — booking confirmed. Shows the reference / transaction id.
export function Confirmation() {
  const { state, dispatch } = useBooking();

  return (
    <div className="space-y-4 text-center">
      <div className="text-4xl">✅</div>
      <h2 className="text-lg font-semibold text-gray-900">Booking confirmed</h2>
      <p className="text-sm text-gray-600">
        {/* TODO: show real booking id / transaction id / amount from the response. */}
        Reference: <span className="font-mono">{state.bookingId ?? "PENDING"}</span>
      </p>

      <button
        onClick={() => dispatch({ type: "RESET" })}
        className="w-full rounded border border-gray-300 px-4 py-2 font-medium text-gray-700 hover:bg-gray-50"
      >
        Book another
      </button>
    </div>
  );
}
