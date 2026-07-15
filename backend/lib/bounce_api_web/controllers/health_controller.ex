defmodule BounceApiWeb.HealthController do
  @moduledoc "Liveness probe."
  use BounceApiWeb, :controller

  def show(conn, _params) do
    json(conn, %{status: "ok"})
  end
end
