defmodule BounceApi.Payments do
  @moduledoc """
  The Payments context — charges a pending booking via the mock Payments API
  and records the outcome on the booking.

  NOTE: Scaffold. Bodies are stubbed with `TODO`s.
  """

  # alias BounceApi.Bookings.Booking            # TODO: uncomment when implementing
  # alias BounceApi.Payments.Client
  # alias BounceApi.Repo

  @doc """
  Charge `booking` using the supplied card details.

  `card_params` (e.g. `%{"card_number" => ...}`) is forwarded to the Payments
  API but never persisted. The amount charged comes from `booking.amount_cents`
  (backend source of truth), NOT from the client.

  TODO:
    1. Build request params from the booking + card details.
    2. Call `Client.create_payment/1`.
    3. On success -> `Booking.payment_changeset/2` with status `paid`,
       transaction_id, last_four_digits, processing_fee; persist.
    4. On decline -> mark `failed`, surface `error_code`/`detail` to the caller.

  Idempotency TODO: guard against double-charge on retry — if the booking already
  has a `transaction_id` / is `paid`, return the existing result instead of
  charging again.
  """
  def charge(_booking, _card_params) do
    # TODO: implement charge flow.
    {:error, :not_implemented}
  end
end
