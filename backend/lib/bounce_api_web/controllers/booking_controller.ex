defmodule BounceApiWeb.BookingController do
  @moduledoc """
  Booking endpoints.

  `create` performs the full checkout in one request: it prices and persists a
  `pending` booking, then charges it via the mock Payments API. This matches the
  mockup's single "Book" action (Placing Booking… → Placed / Retry).
  """
  use BounceApiWeb, :controller

  alias BounceApi.Bookings
  alias BounceApi.Payments

  @doc """
  POST /api/bookings — create the booking and charge it.

  Body: `{num_bags, customer_name, customer_email, card_number}`.
    * 201 — payment succeeded; returns the `paid` booking
    * 402 — payment declined; booking persisted as `failed`; `{error_code, detail}`
    * 422 — invalid input; `{errors}`
  """
  def create(conn, params) do
    with {:ok, booking} <- Bookings.create_booking(params),
         {:ok, paid} <- Payments.charge(booking, params["card_number"]) do
      conn
      |> put_status(:created)
      |> json(paid)
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: translate_errors(changeset)})

      {:error, _failed_booking, error} ->
        conn
        |> put_status(:payment_required)
        |> json(%{error_code: error.error_code, detail: error.detail})
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
