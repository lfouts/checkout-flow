defmodule BounceApi.Bookings do
  @moduledoc """
  The Bookings context — creating and reading bag-storage reservations.

  Pricing lives here so the backend stays the source of truth for the charged
  amount; the client never dictates `amount_cents`.
  """
  import Ecto.Query, warn: false

  alias BounceApi.Repo
  alias BounceApi.Store
  alias BounceApi.Bookings.Booking

  @doc """
  Price a booking (in cents) for `num_bags` at the store's flat per-bag rate.
  """
  def price_booking(num_bags) when is_integer(num_bags) and num_bags >= 1 do
    num_bags * Store.price_per_bag_cents()
  end

  @doc """
  Create a `pending` booking. The amount is computed here from `num_bags` — any
  client-supplied amount/currency is ignored.

  Expects string- or atom-keyed `customer_name`, `customer_email`, `num_bags`.
  Returns `{:ok, %Booking{}}` or `{:error, changeset}`.
  """
  def create_booking(attrs) do
    num_bags = normalize_num_bags(attrs)

    priced =
      attrs
      |> stringify_keys()
      |> Map.take(["customer_name", "customer_email"])
      |> Map.merge(%{
        "num_bags" => num_bags,
        "currency" => Store.currency(),
        "amount_cents" => safe_price(num_bags)
      })

    %Booking{}
    |> Booking.create_changeset(priced)
    |> Repo.insert()
  end

  @doc "Fetch a booking by id. Returns `{:ok, booking}` or `{:error, :not_found}`."
  def get_booking(id) do
    case Repo.get(Booking, id) do
      nil -> {:error, :not_found}
      booking -> {:ok, booking}
    end
  end

  # Price only when we have a valid bag count; otherwise let the changeset report
  # the validation error (amount stays nil -> required error).
  defp safe_price(num_bags) when is_integer(num_bags) and num_bags >= 1,
    do: price_booking(num_bags)

  defp safe_price(_), do: nil

  defp normalize_num_bags(attrs) do
    case stringify_keys(attrs)["num_bags"] do
      n when is_integer(n) -> n
      n when is_binary(n) -> String.to_integer(n)
      _ -> nil
    end
  rescue
    ArgumentError -> nil
  end

  defp stringify_keys(map) do
    Map.new(map, fn {k, v} -> {to_string(k), v} end)
  end
end
