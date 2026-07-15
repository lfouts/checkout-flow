# Bounce — Bag Storage Booking

A booking + checkout flow for reserving bag storage at a single store
("Cody's Cookie Store"). Users choose a number of bags, enter their details and
card, and pay through a mock Payments API — all on one screen, matching the Figma
mockup.

## Stack

- **backend/** — Elixir + [Phoenix](https://www.phoenixframework.org/) (API-only), Ecto + PostgreSQL
- **frontend/** — React + TypeScript ([Vite](https://vitejs.dev/)), Tailwind CSS, TanStack Query

## Prerequisites

- Elixir/Erlang, PostgreSQL (`brew install elixir postgresql@16`)
- Node 20+ / npm

## Running locally

### Backend (http://localhost:4001)

```bash
cd backend
mix deps.get
mix ecto.setup      # create + migrate
mix phx.server
```

Health check: `curl http://localhost:4001/api/health` → `{"status":"ok"}`
(Port defaults to 4001 to avoid clashing with other local dev apps on 4000; override with `PORT`.)

### Frontend (http://localhost:5173)

```bash
cd frontend
npm install
npm run dev
```

The frontend reads the API base URL from `VITE_API_URL` (see `frontend/.env.example`).

## Tests

```bash
cd backend  && mix test     # ExUnit: pricing, charge success/decline, controllers
cd frontend && npm test      # Vitest + RTL: form, price, states
```

## The booking flow

1. `GET /api/store` — the frontend loads the store name + per-bag price.
2. The user sets bag count (footer price updates live) and fills name, email, card.
3. **Book** → `POST /api/bookings` (single request):
   - The backend **prices** the booking (`num_bags × price_per_bag_cents`), persists it
     as `pending`, then **charges** it via the mock Payments API.
   - Success → `201` with the `paid` booking → UI shows **"Booking Placed!"**.
   - Decline → `402 {error_code, detail}`, booking persisted as `failed` → UI shows
     **"Your booking has failed. Please try again."** with a red **Retry** button.

### API

| Method | Path                | Purpose                                  |
| ------ | ------------------- | ---------------------------------------- |
| GET    | `/api/health`       | Liveness                                 |
| GET    | `/api/store`        | Store name, per-bag price, currency      |
| POST   | `/api/bookings`     | Create + charge a booking                |
| GET    | `/api/bookings/:id` | Fetch a booking                          |

## Payments API

Bookings are charged via the provided mock endpoint
`POST https://fullstack-challenge-api.usebounce.io/v1/payments`
(amounts in **cents**, ~20% simulated decline rate). See `backend/lib/bounce_api/payments/`.

## Decisions & architecture notes

- **Pricing**: flat **$5.90 per bag** (from the mockup: 1 bag = $5.90, 2 bags = $11.80).
  Configured in `config :bounce_api, :store` and computed on the **backend** — the client
  never sets the charged amount.
- **Single create+charge endpoint** mirrors the mockup's one **Book** action; each Book/Retry
  is one request. Failed attempts are persisted (`failed`) as an audit trail; Retry is a new request.
- Money is **integer cents** everywhere; formatted only at the view layer.
- **Card numbers are never persisted or logged** — only `last_four_digits` from the payment result.
- Booking status machine: `pending → paid | failed`.
- No dates: the mockup has no drop-off/pick-up pickers, so the booking has none.

## Possible next steps (TODOs)

- Per-request keys to stop a retried booking from charging twice (beyond the current already-`paid` guard).
- Multi-store support (schema + store selection), currently a single configured store.
- Server-persisted store catalog instead of app config.
- Richer client-side card validation (Luhn) and inline field-level errors.
