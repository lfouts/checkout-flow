defmodule BounceApiWeb.WarmupController do
  @moduledoc """
  Pre-warms the (free-tier, cold-starting) mock Payments API so the first real
  booking is fast. The frontend calls this on page load; it returns immediately
  and wakes the payment service in the background.
  """
  use BounceApiWeb, :controller

  alias BounceApi.Payments.Client

  def create(conn, _params) do
    Task.start(fn -> Client.warm() end)

    conn
    |> put_status(:accepted)
    |> json(%{warming: true})
  end
end
