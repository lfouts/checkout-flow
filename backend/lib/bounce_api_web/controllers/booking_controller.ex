defmodule BounceApiWeb.BookingController do
  @moduledoc """
  Booking endpoints.

  `create` currently creates and persists a `pending` booking. The payment charge
  is wired into this same action in the `feature/payment-charge` branch (single
  create+charge request).
  """
  use BounceApiWeb, :controller

  alias BounceApi.Bookings

  @doc """
  POST /api/bookings — create a booking. The amount is priced server-side.
  """
  def create(conn, params) do
    case Bookings.create_booking(params) do
      {:ok, booking} ->
        conn
        |> put_status(:created)
        |> json(booking)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: translate_errors(changeset)})
    end
  end

  @doc "GET /api/bookings/:id — fetch a booking."
  def show(conn, %{"id" => id}) do
    case Bookings.get_booking(id) do
      {:ok, booking} ->
        json(conn, booking)

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "not_found", detail: "Booking not found"})
    end
  end

  defp translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
