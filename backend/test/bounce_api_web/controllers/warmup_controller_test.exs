defmodule BounceApiWeb.WarmupControllerTest do
  use BounceApiWeb.ConnCase, async: true

  test "POST /api/payments/warmup returns 202 immediately", %{conn: conn} do
    conn = post(conn, ~p"/api/payments/warmup")
    assert json_response(conn, 202) == %{"warming" => true}
  end
end
