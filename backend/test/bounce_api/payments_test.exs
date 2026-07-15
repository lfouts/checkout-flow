defmodule BounceApi.PaymentsTest do
  use BounceApi.DataCase, async: true

  alias BounceApi.Bookings
  alias BounceApi.Payments
  alias BounceApi.Payments.Client

  @success %{
    "transaction_id" => "txn_abc123",
    "status" => "completed",
    "amount" => 1180,
    "currency" => "USD",
    "last_four_digits" => "4242",
    "payment_method" => "credit_card",
    "timestamp" => "2026-07-14T10:00:00Z",
    "merchant_reference" => "REF_1",
    "processing_fee" => 64
  }

  defp booking!(attrs \\ %{}) do
    base = %{"customer_name" => "John Doe", "customer_email" => "john@doe.com", "num_bags" => 2}
    {:ok, booking} = Bookings.create_booking(Map.merge(base, attrs))
    booking
  end

  test "charge/2 marks the booking paid and records the payment result on success" do
    Req.Test.stub(Client, fn conn ->
      # The processor is charged the server-computed amount, not a client value.
      assert conn.body_params["amount"] == 1180
      Req.Test.json(conn, @success)
    end)

    assert {:ok, paid} = Payments.charge(booking!(), "4242424242424242")
    assert paid.status == "paid"
    assert paid.transaction_id == "txn_abc123"
    assert paid.last_four_digits == "4242"
    assert paid.processing_fee_cents == 64
  end

  test "charge/2 marks the booking failed and returns the error on decline" do
    Req.Test.stub(Client, fn conn ->
      conn
      |> Plug.Conn.put_resp_content_type("application/json")
      |> Plug.Conn.send_resp(
        400,
        Jason.encode!(%{
          "detail" => %{"detail" => "Insufficient funds available", "error_code" => "INSUFFICIENT_FUNDS"}
        })
      )
    end)

    assert {:error, failed, error} = Payments.charge(booking!(), "4242424242424242")
    assert failed.status == "failed"
    assert error.error_code == "INSUFFICIENT_FUNDS"
    assert error.detail == "Insufficient funds available"
  end

  test "Client.warm/0 pings the service and returns :ok" do
    parent = self()
    Req.Test.stub(Client, fn conn ->
      send(parent, {:warmed, conn.request_path})
      Req.Test.json(conn, %{})
    end)

    assert Client.warm() == :ok
    assert_received {:warmed, "/v1/docs"}
  end

  test "Client.warm/0 returns :ok even when the service errors" do
    Req.Test.stub(Client, fn conn ->
      Plug.Conn.send_resp(conn, 503, "unavailable")
    end)

    assert Client.warm() == :ok
  end

  test "charge/2 does not re-charge an already-paid booking" do
    Req.Test.stub(Client, fn conn -> Req.Test.json(conn, @success) end)
    {:ok, paid} = Payments.charge(booking!(), "4242424242424242")

    # No further stub expectation — a second charge must not hit the processor.
    assert {:ok, ^paid} = Payments.charge(paid, "4242424242424242")
  end
end
