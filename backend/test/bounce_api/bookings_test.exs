defmodule BounceApi.BookingsTest do
  use BounceApi.DataCase, async: true

  alias BounceApi.Bookings
  alias BounceApi.Bookings.Booking

  describe "price_booking/1" do
    test "prices at the store's flat per-bag rate (590 cents)" do
      assert Bookings.price_booking(1) == 590
      assert Bookings.price_booking(2) == 1180
      assert Bookings.price_booking(5) == 2950
    end
  end

  describe "create_booking/1" do
    @valid %{
      "customer_name" => "John Doe",
      "customer_email" => "john@doe.com",
      "num_bags" => 2
    }

    test "creates a pending booking with a server-computed amount" do
      assert {:ok, %Booking{} = booking} = Bookings.create_booking(@valid)
      assert booking.status == "pending"
      assert booking.num_bags == 2
      assert booking.amount_cents == 1180
      assert booking.currency == "USD"
    end

    test "ignores any client-supplied amount (price is server-owned)" do
      attrs = Map.put(@valid, "amount_cents", 1)
      assert {:ok, booking} = Bookings.create_booking(attrs)
      assert booking.amount_cents == 1180
    end

    test "rejects a missing/invalid email" do
      attrs = Map.put(@valid, "customer_email", "not-an-email")
      assert {:error, changeset} = Bookings.create_booking(attrs)
      assert %{customer_email: _} = errors_on(changeset)
    end

    test "rejects fewer than one bag" do
      attrs = Map.put(@valid, "num_bags", 0)
      assert {:error, changeset} = Bookings.create_booking(attrs)
      assert %{num_bags: _} = errors_on(changeset)
    end
  end

  describe "get_booking/1" do
    test "returns the booking when it exists" do
      {:ok, booking} = Bookings.create_booking(@valid)
      assert {:ok, found} = Bookings.get_booking(booking.id)
      assert found.id == booking.id
    end

    test "returns :not_found for an unknown id" do
      assert {:error, :not_found} = Bookings.get_booking(Ecto.UUID.generate())
    end
  end
end
