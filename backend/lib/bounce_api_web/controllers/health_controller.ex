defmodule BounceApiWeb.HealthController do
  @moduledoc "Liveness probe — the one fully-implemented endpoint in the scaffold."
  use BounceApiWeb, :controller

  def show(conn, _params) do
    json(conn, %{status: "ok"})
  end
end
