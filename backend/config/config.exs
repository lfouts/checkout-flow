# Base configuration shared across environments (see dev/test/runtime.exs).
import Config

config :bounce_api,
  ecto_repos: [BounceApi.Repo],
  generators: [timestamp_type: :utc_datetime, binary_id: true]

# Configure the endpoint
config :bounce_api, BounceApiWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: BounceApiWeb.ErrorJSON],
    layout: false
  ]

# Configure Elixir's Logger
config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# The (single) store this product books storage for.
# Pricing is a flat rate per bag; all money is in integer cents.
config :bounce_api, :store,
  name: "Cody's Cookie Store",
  price_per_bag_cents: 590,
  currency: "USD"

# Mock Payments API (see https://fullstack-challenge-api.usebounce.io/v1/docs).
# Base URL is overridable per-environment / via runtime env (PAYMENTS_API_URL).
config :bounce_api, :payments,
  base_url: "https://fullstack-challenge-api.usebounce.io/v1"

# Origins allowed to call the JSON API (CORS). Overridden in prod via runtime.exs.
config :bounce_api, :cors_origins, ["http://localhost:5173"]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
