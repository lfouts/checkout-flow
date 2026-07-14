// Wizard state for the booking flow. Kept intentionally small — a skeleton.

export const STEPS = [
  "dates",
  "summary",
  "payment",
  "confirmation",
] as const;

export type Step = (typeof STEPS)[number];

export interface BookingForm {
  // Reservation
  numBags: number;
  dropoffAt: string;
  pickupAt: string;
  // Customer
  customerName: string;
  customerEmail: string;
  // Payment (card number is never persisted; used only to submit the charge)
  cardNumber: string;
}

export interface BookingState {
  stepIndex: number;
  form: BookingForm;
  // Set once the booking is created/paid on the backend.
  bookingId: string | null;
}

export const initialBookingState: BookingState = {
  stepIndex: 0,
  form: {
    numBags: 1,
    dropoffAt: "",
    pickupAt: "",
    customerName: "",
    customerEmail: "",
    cardNumber: "",
  },
  bookingId: null,
};

export type BookingAction =
  | { type: "UPDATE_FORM"; patch: Partial<BookingForm> }
  | { type: "NEXT" }
  | { type: "BACK" }
  | { type: "GO_TO"; stepIndex: number }
  | { type: "SET_BOOKING_ID"; bookingId: string }
  | { type: "RESET" };

export function bookingReducer(
  state: BookingState,
  action: BookingAction,
): BookingState {
  switch (action.type) {
    case "UPDATE_FORM":
      return { ...state, form: { ...state.form, ...action.patch } };
    case "NEXT":
      return {
        ...state,
        stepIndex: Math.min(state.stepIndex + 1, STEPS.length - 1),
      };
    case "BACK":
      return { ...state, stepIndex: Math.max(state.stepIndex - 1, 0) };
    case "GO_TO":
      return { ...state, stepIndex: action.stepIndex };
    case "SET_BOOKING_ID":
      return { ...state, bookingId: action.bookingId };
    case "RESET":
      return initialBookingState;
    default:
      return state;
  }
}
