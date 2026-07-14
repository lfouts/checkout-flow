defmodule BounceApi.Payments.Client do
  @moduledoc """
  Thin HTTP client for the mock Payments API.

  `POST {base_url}/payments` — accepts customer info (name, email), payment
  details (amount in cents, currency) and a card number; returns a
  `PaymentResponse` or a `PaymentError` (~20% simulated decline rate).

  See https://fullstack-challenge-api.usebounce.io/v1/docs.

  NOTE: Scaffold — the request/response mapping is stubbed with `TODO`s.
  Card numbers pass through here but are NEVER logged or persisted.
  """

  @doc """
  Submit a payment to the mock API.

  `params` should carry customer + payment + card fields per the API schema.

  TODO: build and send the request, e.g.:

      base_url()
      |> Req.new(url: "/payments", json: params)
      |> Req.post()

  then map:
    * 200 -> `{:ok, payment_response_map}`
    * 4xx `PaymentError` -> `{:error, %{error_code: ..., detail: ...}}`
    * 422 `HTTPValidationError` / transport errors -> `{:error, reason}`
  """
  def create_payment(_params) do
    # TODO: implement Req call + response mapping.
    {:error, :not_implemented}
  end

  @doc "Base URL for the Payments API (configurable per env)."
  def base_url do
    Application.get_env(:bounce_api, :payments, [])
    |> Keyword.get(:base_url, "https://fullstack-challenge-api.usebounce.io/v1")
  end
end
