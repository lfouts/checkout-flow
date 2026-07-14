defmodule BounceApi.Repo do
  use Ecto.Repo,
    otp_app: :bounce_api,
    adapter: Ecto.Adapters.Postgres
end
