import Config

# Runs in all environments after compilation, before boot. Production config and
# secrets are read from environment variables here.

# Releases only start the web server when PHX_SERVER is set (e.g. bin/bounce_api start).
if System.get_env("PHX_SERVER") do
  config :bounce_api, BounceApiWeb.Endpoint, server: true
end

# Default to 4001 (port 4000 is commonly taken by other local dev apps).
# Override anywhere with the PORT env var.
config :bounce_api, BounceApiWeb.Endpoint,
  http: [port: String.to_integer(System.get_env("PORT", "4001"))]

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise "environment variable DATABASE_URL is missing (e.g. ecto://USER:PASS@HOST/DATABASE)"

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise "environment variable SECRET_KEY_BASE is missing (generate one with: mix phx.gen.secret)"

  config :bounce_api, BounceApi.Repo,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

  config :bounce_api, BounceApiWeb.Endpoint,
    url: [host: System.get_env("PHX_HOST") || "example.com", port: 443, scheme: "https"],
    http: [ip: {0, 0, 0, 0, 0, 0, 0, 0}],
    secret_key_base: secret_key_base
end
