defmodule BounceApiWeb.BookingController do
  @moduledoc """
  Booking endpoints. Scaffold — actions return `501 Not Implemented` with a
  `TODO` marker until the Bookings/Payments contexts are built out.
  """
  use BounceApiWeb, :controller

  # alias BounceApi.Bookings
  # alias BounceApi.Payments

  @doc """
  POST /api/bookings — create a pending booking.

  TODO: validate params, call `Bookings.create_booking/1` (which prices the
  booking server-side), render the created booking as JSON.
  """
  def create(conn, _params) do
    not_implemented(conn, "create booking")
  end

  @doc """
  GET /api/bookings/:id — fetch a booking.

  TODO: `Bookings.get_booking/1`; 404 when missing, else render the booking.
  """
  def show(conn, %{"id" => _id}) do
    not_implemented(conn, "show booking")
  end

  @doc """
  POST /api/bookings/:id/payment — charge the booking via the mock Payments API.

  TODO: load the booking, call `Payments.charge/2` with the card details,
  handle decline (surface error_code/detail) and idempotent retries.
  """
  def pay(conn, %{"id" => _id}) do
    not_implemented(conn, "pay booking")
  end

  defp not_implemented(conn, what) do
    conn
    |> put_status(:not_implemented)
    |> json(%{error: "not_implemented", detail: "TODO: #{what}"})
  end
end
