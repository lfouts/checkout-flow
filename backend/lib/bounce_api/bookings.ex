defmodule BounceApi.Bookings do
  @moduledoc """
  The Bookings context — creating and reading bag-storage reservations.

  Pricing lives here so the backend stays the source of truth for the charged
  amount; the client never dictates `amount_cents`.

  NOTE: This is a scaffold. Function bodies are stubbed with `TODO`s.
  """

  # alias BounceApi.Bookings.Booking  # TODO: uncomment when implementing bodies

  @doc """
  Compute the price (in cents) for a set of booking params.

  TODO: implement real pricing. Likely: base rate per bag per day, derived from
  `num_bags` and the `dropoff_at`/`pickup_at` span. Return `{:ok, amount_cents}`.
  """
  def price_booking(_attrs) do
    # TODO: replace placeholder with real pricing rules.
    {:ok, 0}
  end

  @doc """
  Create a `pending` booking from customer + reservation params.

  TODO: merge server-computed `amount_cents` from `price_booking/1` into attrs,
  build `Booking.create_changeset/2`, and insert via `BounceApi.Repo`.
  Return `{:ok, %Booking{}}` or `{:error, changeset}`.
  """
  def create_booking(_attrs) do
    # TODO: implement persistence.
    {:error, :not_implemented}
  end

  @doc """
  Fetch a booking by id.

  TODO: `BounceApi.Repo.get(Booking, id)`; return `{:ok, booking}` or `{:error, :not_found}`.
  """
  def get_booking(_id) do
    # TODO: implement lookup.
    {:error, :not_implemented}
  end
end
