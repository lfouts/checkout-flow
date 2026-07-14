interface BagStepperProps {
  value: number;
  onChange: (next: number) => void;
  min?: number;
}

// The [-] n [+] control from the mockup.
export function BagStepper({ value, onChange, min = 1 }: BagStepperProps) {
  return (
    <div className="flex items-center gap-3">
      <button
        type="button"
        aria-label="Remove a bag"
        disabled={value <= min}
        onClick={() => onChange(Math.max(min, value - 1))}
        className="h-8 w-8 rounded bg-indigo-100 text-lg font-medium text-indigo-700 disabled:opacity-40"
      >
        −
      </button>
      <span className="w-6 text-center tabular-nums" aria-live="polite">
        {value}
      </span>
      <button
        type="button"
        aria-label="Add a bag"
        onClick={() => onChange(value + 1)}
        className="h-8 w-8 rounded bg-indigo-500 text-lg font-medium text-white hover:bg-indigo-600"
      >
        +
      </button>
    </div>
  );
}
