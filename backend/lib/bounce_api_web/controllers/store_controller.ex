defmodule BounceApiWeb.StoreController do
  @moduledoc "Exposes the single store's details (name + per-bag price) to the frontend."
  use BounceApiWeb, :controller

  alias BounceApi.Store

  def show(conn, _params) do
    json(conn, Store.info())
  end
end
