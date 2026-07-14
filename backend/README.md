# BounceApi

The Phoenix (API-only) backend for the Bounce bag-storage booking app. See the
[root README](../README.md) for the full picture (flow, endpoints, decisions).

## Setup

```bash
mix setup        # deps + ecto.create + ecto.migrate
mix phx.server   # or: iex -S mix phx.server
```

The API listens on [`localhost:4001`](http://localhost:4001) by default (4000 is
commonly taken by other local dev apps; override with the `PORT` env var).
Health check: `curl localhost:4001/api/health` → `{"status":"ok"}`.

```bash
mix test         # ExUnit suite
```

## Local PostgreSQL

The app expects PostgreSQL on `localhost:5432` with a `postgres`/`postgres`
superuser role (see `config/dev.exs`). Installed via `brew install postgresql@16`.

### Make it start automatically (do this once, from your own Terminal.app)

```bash
brew services start postgresql@16
brew services list          # postgresql@16 should show "started"
```

Run this from a real Terminal (a GUI login session). `brew services` relies on a
per-user launchd GUI domain, so starting it from a non-GUI shell (SSH, an editor
task runner, an automation/agent shell) can report success while launchd never
actually spawns Postgres — it "starts" but nothing binds to 5432.

### Troubleshooting

**`Postgrex.Error ... FATAL 57P01 (admin_shutdown)` / `connection refused`** —
Postgres isn't running (or was shut down under the app). Check and start it:

```bash
lsof -iTCP:5432 -sTCP:LISTEN          # is anything listening?
brew services start postgresql@16      # preferred (from your Terminal)
```

If `brew services` won't bind (the launchd-domain issue above), start it directly
as a fallback — this instance is not boot-durable, but it revives the DB now:

```bash
pg_ctl -D /opt/homebrew/var/postgresql@16 -l /tmp/pg.log start
```

**`address already in use` (`:eaddrinuse`) on boot** — a previous `mix phx.server`
is still holding the port:

```bash
lsof -ti tcp:4001 | xargs kill        # free port 4001
# or just run on another port:
PORT=4005 mix phx.server
```

**Reset the dev database** (drops + recreates + migrates):

```bash
mix ecto.reset
```

## Learn more

* Phoenix guides: https://phoenix.hexdocs.pm/overview.html
* Docs: https://phoenix.hexdocs.pm
