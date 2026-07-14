defmodule BounceApi.Payments do
  @moduledoc """
  The Payments context — charges a booking via the mock Payments API and records
  the outcome on the booking.
  """
  alias BounceApi.Repo
  alias BounceApi.Bookings.Booking
  alias BounceApi.Payments.Client

  @doc """
  Charge `booking` using `card_number`.

  The amount charged is `booking.amount_cents` (the backend-computed price), never
  a client-supplied value. The card number is forwarded to the processor but never
  persisted — only `last_four_digits` from the response is stored.

  Idempotent: an already-`paid` booking is returned as-is without re-charging.

  Returns `{:ok, booking}` (status `paid`) or
  `{:error, booking, %{error_code:, detail:}}` (status `failed`).
  """
  def charge(%Booking{status: "paid"} = booking, _card_number), do: {:ok, booking}

  def charge(%Booking{} = booking, card_number) do
    params = %{
      name: booking.customer_name,
      email: booking.customer_email,
      amount: booking.amount_cents,
      currency: booking.currency,
      card_number: card_number
    }

    case Client.create_payment(params) do
      {:ok, payment} ->
        {:ok, mark_paid(booking, payment)}

      {:error, error} ->
        {:error, mark_failed(booking), error}
    end
  end

  defp mark_paid(booking, payment) do
    booking
    |> Booking.payment_changeset(%{
      status: "paid",
      transaction_id: payment["transaction_id"],
      last_four_digits: payment["last_four_digits"],
      processing_fee_cents: payment["processing_fee"]
    })
    |> Repo.update!()
  end

  defp mark_failed(booking) do
    booking
    |> Booking.payment_changeset(%{status: "failed"})
    |> Repo.update!()
  end
end
