defmodule BounceApiWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :bounce_api

  # Serve static files from priv/static.
  plug Plug.Static,
    at: "/",
    from: :bounce_api,
    gzip: not code_reloading?,
    only: BounceApiWeb.static_paths(),
    raise_on_missing_only: code_reloading?

  if code_reloading? do
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :bounce_api
  end

  plug Plug.RequestId

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head

  # Allow the Vite dev server (and configured origins) to call the JSON API.
  plug CORSPlug, origin: &BounceApiWeb.Endpoint.cors_origins/0

  plug BounceApiWeb.Router

  @doc """
  CORS origins allowed to call the API. Configured via `:cors_origins`
  (see `config/*.exs`); defaults to the Vite dev server.
  """
  def cors_origins do
    Application.get_env(:bounce_api, :cors_origins, ["http://localhost:5173"])
  end
end
