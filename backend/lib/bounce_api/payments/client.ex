defmodule BounceApi.Payments.Client do
  @moduledoc """
  HTTP client for the mock Payments API.

  `POST {base_url}/payments` with `{name, email, amount, currency, card_number}`
  (amount in cents). Returns a `PaymentResponse` or, ~20% of the time, a decline.

  See https://fullstack-challenge-api.usebounce.io/v1/docs.

  The card number is forwarded to the payment processor but never logged here.
  """
  require Logger

  @doc """
  Submit a payment.

  `params` must contain `:name`, `:email`, `:amount` (cents), `:currency`,
  `:card_number`.

  Returns:
    * `{:ok, payment_response_map}` on success (HTTP 200)
    * `{:error, %{error_code: code, detail: message}}` on a decline / validation error
    * `{:error, %{error_code: "network_error", detail: ...}}` on transport failure
  """
  def create_payment(params) do
    case Req.post(req(), url: "/payments", json: params) do
      {:ok, %{status: 200, body: body}} ->
        {:ok, body}

      {:ok, %{status: status, body: body}} when status in 400..499 ->
        {:error, decode_error(body)}

      {:ok, %{status: status}} ->
        Logger.warning("Payments API returned unexpected status #{status}")
        {:error, %{error_code: "payment_error", detail: "Unexpected response from payment processor"}}

      {:error, reason} ->
        Logger.warning("Payments API request failed: #{inspect(reason)}")
        {:error, %{error_code: "network_error", detail: "Could not reach payment processor"}}
    end
  end

  # The mock API nests the error under a top-level "detail" key:
  #   {"detail": {"detail": "Insufficient funds available", "error_code": "INSUFFICIENT_FUNDS"}}
  defp decode_error(%{"detail" => %{"error_code" => code} = inner}) do
    %{error_code: code, detail: inner["detail"]}
  end

  defp decode_error(%{"detail" => detail}) when is_binary(detail) do
    %{error_code: "payment_declined", detail: detail}
  end

  defp decode_error(_body) do
    %{error_code: "payment_declined", detail: "Payment was declined"}
  end

  defp req do
    config = Application.get_env(:bounce_api, :payments, [])

    [base_url: base_url()]
    |> Keyword.merge(Keyword.get(config, :req_options, []))
    |> Req.new()
  end

  @doc "Base URL for the Payments API (configurable per env)."
  def base_url do
    Application.get_env(:bounce_api, :payments, [])
    |> Keyword.get(:base_url, "https://fullstack-challenge-api.usebounce.io/v1")
  end
end
