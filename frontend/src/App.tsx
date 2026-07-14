import { ApiHealthBadge } from "./components/ApiHealthBadge";
import { BookingProvider } from "./features/booking/BookingContext";
import { BookingWizard } from "./features/booking/BookingWizard";

function App() {
  return (
    <div className="min-h-screen bg-gray-50">
      <header className="border-b border-gray-200 bg-white">
        <div className="mx-auto flex max-w-md items-center justify-between px-6 py-4">
          <span className="font-semibold text-indigo-600">Bounce · Store your bags</span>
          <ApiHealthBadge />
        </div>
      </header>

      <main className="px-6 py-10">
        <BookingProvider>
          <BookingWizard />
        </BookingProvider>
      </main>
    </div>
  );
}

export default App;
