defmodule BounceApiWeb.Router do
  use BounceApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BounceApiWeb do
    pipe_through :api

    get "/health", HealthController, :show

    get "/store", StoreController, :show

    # Pre-wake the cold-starting payments service (called on page load).
    post "/payments/warmup", WarmupController, :create

    post "/bookings", BookingController, :create
    get "/bookings/:id", BookingController, :show
  end
end
