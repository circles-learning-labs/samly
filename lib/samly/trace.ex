defmodule Samly.Trace do
  def handle(message, data \\ %{}) do
    case Application.get_env(:samly, Samly.Trace)[:handler] do
      nil -> nil
      handler -> handler.handle(message, data)
    end
  end
end
