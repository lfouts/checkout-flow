defmodule BounceApi.Bookings.Booking do
  @moduledoc """
  A reservation for bag storage at the store.

  Money is stored as integer cents. `status` follows `pending -> paid | failed`.
  Card numbers are never stored — only `last_four_digits` from the payment result.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @statuses ~w(pending paid failed)

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Jason.Encoder,
           only: [
             :id,
             :customer_name,
             :customer_email,
             :num_bags,
             :dropoff_at,
             :pickup_at,
             :currency,
             :amount_cents,
             :processing_fee_cents,
             :status,
             :transaction_id,
             :last_four_digits,
             :inserted_at,
             :updated_at
           ]}
  schema "bookings" do
    field :customer_name, :string
    field :customer_email, :string

    field :num_bags, :integer
    field :dropoff_at, :utc_datetime
    field :pickup_at, :utc_datetime

    field :currency, :string, default: "USD"
    field :amount_cents, :integer
    field :processing_fee_cents, :integer

    field :status, :string, default: "pending"

    field :transaction_id, :string
    field :last_four_digits, :string

    timestamps(type: :utc_datetime)
  end

  @doc """
  Changeset for creating a booking (customer + reservation details).

  TODO: validate `pickup_at` is after `dropoff_at`, `num_bags > 0`, and a
  reasonable email format. `amount_cents` is set by the backend pricing logic,
  not accepted from the client.
  """
  def create_changeset(booking, attrs) do
    booking
    |> cast(attrs, [
      :customer_name,
      :customer_email,
      :num_bags,
      :dropoff_at,
      :pickup_at,
      :currency,
      :amount_cents
    ])
    |> validate_required([
      :customer_name,
      :customer_email,
      :num_bags,
      :dropoff_at,
      :pickup_at,
      :amount_cents
    ])
    |> validate_inclusion(:status, @statuses)
  end

  @doc """
  Changeset applied after a payment attempt resolves — records the outcome.

  TODO: called from `BounceApi.Payments.charge/2` with the `PaymentResponse`
  fields (transaction_id, last_four_digits, processing_fee) on success, or a
  `failed` status on decline.
  """
  def payment_changeset(booking, attrs) do
    booking
    |> cast(attrs, [:status, :transaction_id, :last_four_digits, :processing_fee_cents])
    |> validate_inclusion(:status, @statuses)
  end
end
