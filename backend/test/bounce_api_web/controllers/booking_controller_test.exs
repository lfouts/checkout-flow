defmodule BounceApiWeb.BookingControllerTest do
  use BounceApiWeb.ConnCase, async: true

  alias BounceApi.Payments.Client

  @valid %{
    "customer_name" => "John Doe",
    "customer_email" => "john@doe.com",
    "num_bags" => 2,
    "card_number" => "4242424242424242"
  }

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

  describe "POST /api/bookings" do
    test "201 with a paid booking when the charge succeeds", %{conn: conn} do
      Req.Test.stub(Client, fn c -> Req.Test.json(c, @success) end)

      body = conn |> post(~p"/api/bookings", @valid) |> json_response(201)

      assert body["status"] == "paid"
      assert body["amount_cents"] == 1180
      assert body["transaction_id"] == "txn_abc123"
      assert body["last_four_digits"] == "4242"
    end

    test "402 with the error when the charge is declined", %{conn: conn} do
      Req.Test.stub(Client, fn c ->
        c
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.send_resp(
          400,
          Jason.encode!(%{"detail" => %{"detail" => "Declined by issuer", "error_code" => "CARD_DECLINED"}})
        )
      end)

      body = conn |> post(~p"/api/bookings", @valid) |> json_response(402)
      assert body["error_code"] == "CARD_DECLINED"
      assert body["detail"] == "Declined by issuer"
    end

    test "422 on invalid input (no charge attempted)", %{conn: conn} do
      conn = post(conn, ~p"/api/bookings", Map.put(@valid, "customer_email", "nope"))
      assert %{"errors" => %{"customer_email" => _}} = json_response(conn, 422)
    end
  end

  describe "GET /api/bookings/:id" do
    test "fetches an existing booking", %{conn: conn} do
      Req.Test.stub(Client, fn c -> Req.Test.json(c, @success) end)
      id = post(conn, ~p"/api/bookings", @valid) |> json_response(201) |> Map.get("id")

      conn = get(conn, ~p"/api/bookings/#{id}")
      assert json_response(conn, 200)["id"] == id
    end

    test "404s for an unknown id", %{conn: conn} do
      conn = get(conn, ~p"/api/bookings/#{Ecto.UUID.generate()}")
      assert json_response(conn, 404)
    end
  end
end
