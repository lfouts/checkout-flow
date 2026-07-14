defmodule BounceApi.Store do
  @moduledoc """
  The single store this product books storage for. Backed by application config
  (`config :bounce_api, :store, ...`). A real app would load this from the database.
  """

  @doc "Store details for display + pricing."
  def info do
    config = Application.get_env(:bounce_api, :store, [])

    %{
      name: Keyword.get(config, :name, "Store"),
      price_per_bag_cents: Keyword.get(config, :price_per_bag_cents, 0),
      currency: Keyword.get(config, :currency, "USD")
    }
  end

  def price_per_bag_cents, do: info().price_per_bag_cents
  def currency, do: info().currency
end
