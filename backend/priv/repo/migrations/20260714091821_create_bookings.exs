defmodule BounceApi.Repo.Migrations.CreateBookings do
  use Ecto.Migration

  def change do
    create table(:bookings, primary_key: false) do
      add :id, :binary_id, primary_key: true

      # Customer
      add :customer_name, :string, null: false
      add :customer_email, :string, null: false

      # Booking details
      add :num_bags, :integer, null: false

      # Money — always integer cents. Backend is the source of truth for the amount.
      add :currency, :string, null: false, default: "USD"
      add :amount_cents, :integer, null: false
      add :processing_fee_cents, :integer

      # Lifecycle: pending -> paid | failed
      add :status, :string, null: false, default: "pending"

      # Payment result. NOTE: we never persist full card numbers, only the last four.
      add :transaction_id, :string
      add :last_four_digits, :string

      timestamps(type: :utc_datetime)
    end

    create index(:bookings, [:status])
    create unique_index(:bookings, [:transaction_id])
  end
end
