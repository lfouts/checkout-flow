import { useBooking } from "../BookingContext";

// Step 3 — customer details + card. Submitting should create the booking and
// charge it via the backend. Card data is sent once and never stored client-side.
export function CustomerAndPayment() {
  const { state, dispatch } = useBooking();
  const { form } = state;

  function handleSubmit() {
    // TODO: call api.createBooking(...) then api.payBooking(...).
    // Handle ~20% decline: surface error_code/detail and allow retry without
    // creating a duplicate booking. On success, dispatch SET_BOOKING_ID + NEXT.
    dispatch({ type: "NEXT" });
  }

  return (
    <div className="space-y-4">
      <h2 className="text-lg font-semibold text-gray-900">Your details &amp; payment</h2>

      <label className="block">
        <span className="text-sm text-gray-700">Full name</span>
        <input
          value={form.customerName}
          onChange={(e) =>
            dispatch({ type: "UPDATE_FORM", patch: { customerName: e.target.value } })
          }
          className="mt-1 w-full rounded border border-gray-300 px-3 py-2"
        />
      </label>

      <label className="block">
        <span className="text-sm text-gray-700">Email</span>
        <input
          type="email"
          value={form.customerEmail}
          onChange={(e) =>
            dispatch({ type: "UPDATE_FORM", patch: { customerEmail: e.target.value } })
          }
          className="mt-1 w-full rounded border border-gray-300 px-3 py-2"
        />
      </label>

      <label className="block">
        <span className="text-sm text-gray-700">Card number</span>
        <input
          inputMode="numeric"
          autoComplete="cc-number"
          placeholder="4242 4242 4242 4242"
          value={form.cardNumber}
          onChange={(e) =>
            dispatch({ type: "UPDATE_FORM", patch: { cardNumber: e.target.value } })
          }
          className="mt-1 w-full rounded border border-gray-300 px-3 py-2"
        />
      </label>

      {/* TODO: validation + loading/error states around the charge request. */}

      <div className="flex gap-3">
        <button
          onClick={() => dispatch({ type: "BACK" })}
          className="flex-1 rounded border border-gray-300 px-4 py-2 font-medium text-gray-700 hover:bg-gray-50"
        >
          Back
        </button>
        <button
          onClick={handleSubmit}
          className="flex-1 rounded bg-indigo-600 px-4 py-2 font-medium text-white hover:bg-indigo-700"
        >
          Pay &amp; book
        </button>
      </div>
    </div>
  );
}
