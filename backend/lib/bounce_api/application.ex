defmodule BounceApi.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BounceApi.Repo,
      # Serve requests (typically the last entry).
      BounceApiWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: BounceApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BounceApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
