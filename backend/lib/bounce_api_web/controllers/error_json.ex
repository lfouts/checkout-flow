defmodule BounceApiWeb.ErrorJSON do
  @moduledoc "Renders JSON error responses (wired up in config/config.exs)."

  # Falls back to the status message for the template, e.g. "404.json" -> "Not Found".
  def render(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end
end
