defmodule BounceApiWeb.StoreControllerTest do
  use BounceApiWeb.ConnCase, async: true

  test "GET /api/store returns the store name and per-bag price", %{conn: conn} do
    conn = get(conn, ~p"/api/store")

    assert %{
             "name" => "Cody's Cookie Store",
             "price_per_bag_cents" => 590,
             "currency" => "USD"
           } = json_response(conn, 200)
  end
end
