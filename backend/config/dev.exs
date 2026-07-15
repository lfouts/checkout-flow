import Config

config :bounce_api, BounceApi.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "bounce_api_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# Dev endpoint: loopback only, with code reloading and friendly error pages.
config :bounce_api, BounceApiWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "k37sELkkP+82rjovAhsJFQKDs7eEcAed/zTSY6G45F8o9GoY2LisDoAoWMSTwxs9"

config :logger, :default_formatter, format: "[$level] $message\n"
config :phoenix, :stacktrace_depth, 20
config :phoenix, :plug_init_mode, :runtime
