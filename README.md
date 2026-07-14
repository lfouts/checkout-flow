# Bounce — Bag Storage Booking

A booking + checkout flow for reserving bag storage at a single store. Users pick
drop-off/pick-up times and a number of bags, then pay through a mock Payments API.

This repository is a **scaffold** — the structure, tooling, and integration points
are in place, with real booking/pricing/payment logic marked by `TODO`s.

## Stack

- **backend/** — Elixir + [Phoenix](https://www.phoenixframework.org/) (API-only), Ecto + PostgreSQL
- **frontend/** — React + TypeScript ([Vite](https://vitejs.dev/)), Tailwind CSS, TanStack Query, React Router

## Prerequisites

- Elixir/Erlang, PostgreSQL (`brew install elixir postgresql@16`)
- Node 20+ / npm

## Running locally

### Backend (http://localhost:4001)

```bash
cd backend
mix deps.get
mix ecto.create
mix ecto.migrate
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

## Payments API

Bookings are charged via the provided mock endpoint:
`POST https://fullstack-challenge-api.usebounce.io/v1/payments`
(amounts in **cents**, ~20% simulated decline rate). See `backend/lib/bounce_api/payments/`.

## Architecture notes

- All monetary values are stored and transmitted as **integer cents**.
- **Card numbers are never persisted or logged** — only `last_four_digits` is stored.
- **Pricing is computed on the backend** (source of truth); the client never sets the charged amount.
- Booking status machine: `pending → paid | failed`.
