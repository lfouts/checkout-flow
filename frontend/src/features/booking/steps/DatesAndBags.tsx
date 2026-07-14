import { useBooking } from "../BookingContext";

// Step 1 — choose number of bags and drop-off / pick-up times.
export function DatesAndBags() {
  const { state, dispatch } = useBooking();
  const { form } = state;

  return (
    <div className="space-y-4">
      <h2 className="text-lg font-semibold text-gray-900">Your bags &amp; dates</h2>

      <label className="block">
        <span className="text-sm text-gray-700">Number of bags</span>
        <input
          type="number"
          min={1}
          value={form.numBags}
          onChange={(e) =>
            dispatch({
              type: "UPDATE_FORM",
              patch: { numBags: Number(e.target.value) },
            })
          }
          className="mt-1 w-full rounded border border-gray-300 px-3 py-2"
        />
      </label>

      <label className="block">
        <span className="text-sm text-gray-700">Drop-off</span>
        <input
          type="datetime-local"
          value={form.dropoffAt}
          onChange={(e) =>
            dispatch({ type: "UPDATE_FORM", patch: { dropoffAt: e.target.value } })
          }
          className="mt-1 w-full rounded border border-gray-300 px-3 py-2"
        />
      </label>

      <label className="block">
        <span className="text-sm text-gray-700">Pick-up</span>
        <input
          type="datetime-local"
          value={form.pickupAt}
          onChange={(e) =>
            dispatch({ type: "UPDATE_FORM", patch: { pickupAt: e.target.value } })
          }
          className="mt-1 w-full rounded border border-gray-300 px-3 py-2"
        />
      </label>

      {/* TODO: client-side validation (pickup after dropoff, num_bags > 0). */}

      <button
        onClick={() => dispatch({ type: "NEXT" })}
        className="w-full rounded bg-indigo-600 px-4 py-2 font-medium text-white hover:bg-indigo-700"
      >
        Continue
      </button>
    </div>
  );
}
