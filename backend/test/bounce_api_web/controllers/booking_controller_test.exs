defmodule BounceApiWeb.BookingControllerTest do
  use BounceApiWeb.ConnCase, async: true

  @valid %{
    "customer_name" => "John Doe",
    "customer_email" => "john@doe.com",
    "num_bags" => 2
  }

  describe "POST /api/bookings" do
    test "creates a booking priced server-side", %{conn: conn} do
      conn = post(conn, ~p"/api/bookings", @valid)
      body = json_response(conn, 201)

      assert body["status"] == "pending"
      assert body["num_bags"] == 2
      assert body["amount_cents"] == 1180
    end

    test "returns 422 with errors on invalid input", %{conn: conn} do
      conn = post(conn, ~p"/api/bookings", Map.put(@valid, "customer_email", "nope"))
      assert %{"errors" => %{"customer_email" => _}} = json_response(conn, 422)
    end
  end

  describe "GET /api/bookings/:id" do
    test "fetches an existing booking", %{conn: conn} do
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
