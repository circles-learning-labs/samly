defmodule Samly.Trace.Handler do
  @moduledoc """
  Specification for Samly (external) trace handler.
  """
  @doc """
  Handles passing tracing and error information to an external handler.

  Intended for debugging Samly's interaction with IdPs and clients.
  Return value is ignored.
  """
  @callback handle(String.t(), keyword()) :: any()
end
