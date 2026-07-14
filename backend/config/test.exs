import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :bounce_api, BounceApi.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "bounce_api_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :bounce_api, BounceApiWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "wk6gOPkOHKlhgindEmv4wVE69YRgsIoVSdkiTL98LTVpoVUa5hSeGwzzxyMQOK71",
  server: false

# Route the Payments client through Req.Test so tests can stub the mock API
# without real HTTP. Stub per-test with `Req.Test.stub(BounceApi.Payments.Client, fn conn -> ... end)`.
config :bounce_api, :payments,
  base_url: "http://payments.test/v1",
  req_options: [plug: {Req.Test, BounceApi.Payments.Client}]

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Sort query params output of verified routes for robust url comparisons
config :phoenix,
  sort_verified_routes_query_params: true
