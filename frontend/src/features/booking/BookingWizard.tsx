import { useBooking } from "./BookingContext";
import { STEPS } from "./bookingState";
import { DatesAndBags } from "./steps/DatesAndBags";
import { Summary } from "./steps/Summary";
import { CustomerAndPayment } from "./steps/CustomerAndPayment";
import { Confirmation } from "./steps/Confirmation";

const STEP_LABELS: Record<(typeof STEPS)[number], string> = {
  dates: "Bags",
  summary: "Review",
  payment: "Payment",
  confirmation: "Done",
};

export function BookingWizard() {
  const { state } = useBooking();
  const current = STEPS[state.stepIndex];

  return (
    <div className="mx-auto max-w-md rounded-xl border border-gray-200 bg-white p-6 shadow-sm">
      {/* Stepper */}
      <ol className="mb-6 flex items-center justify-between text-xs">
        {STEPS.map((step, i) => (
          <li
            key={step}
            className={
              i <= state.stepIndex ? "font-semibold text-indigo-600" : "text-gray-400"
            }
          >
            {i + 1}. {STEP_LABELS[step]}
          </li>
        ))}
      </ol>

      {current === "dates" && <DatesAndBags />}
      {current === "summary" && <Summary />}
      {current === "payment" && <CustomerAndPayment />}
      {current === "confirmation" && <Confirmation />}
    </div>
  );
}
