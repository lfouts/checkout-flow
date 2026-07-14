import { useBooking } from "../BookingContext";

// Step 2 — review the reservation and see the price.
// NOTE: the charged amount is computed by the backend; this is display-only.
export function Summary() {
  const { state, dispatch } = useBooking();
  const { form } = state;

  return (
    <div className="space-y-4">
      <h2 className="text-lg font-semibold text-gray-900">Review</h2>

      <dl className="space-y-2 text-sm">
        <div className="flex justify-between">
          <dt className="text-gray-500">Bags</dt>
          <dd className="text-gray-900">{form.numBags}</dd>
        </div>
        <div className="flex justify-between">
          <dt className="text-gray-500">Drop-off</dt>
          <dd className="text-gray-900">{form.dropoffAt || "—"}</dd>
        </div>
        <div className="flex justify-between">
          <dt className="text-gray-500">Pick-up</dt>
          <dd className="text-gray-900">{form.pickupAt || "—"}</dd>
        </div>
        <div className="flex justify-between border-t border-gray-200 pt-2 font-medium">
          <dt className="text-gray-900">Total</dt>
          {/* TODO: fetch price from backend (POST/preview) and format cents -> currency. */}
          <dd className="text-gray-900">$—.——</dd>
        </div>
      </dl>

      <div className="flex gap-3">
        <button
          onClick={() => dispatch({ type: "BACK" })}
          className="flex-1 rounded border border-gray-300 px-4 py-2 font-medium text-gray-700 hover:bg-gray-50"
        >
          Back
        </button>
        <button
          onClick={() => dispatch({ type: "NEXT" })}
          className="flex-1 rounded bg-indigo-600 px-4 py-2 font-medium text-white hover:bg-indigo-700"
        >
          Continue
        </button>
      </div>
    </div>
  );
}
