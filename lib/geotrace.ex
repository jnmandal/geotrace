defmodule Geotrace do
  @moduledoc """
  Documentation for Geotrace.
  """

  @server_name GT

  def geocode_async(query) do
    GenServer.call(@server_name, {:geocode, query})
  end

  def query_history() do
    GenServer.call(@server_name, :history)
  end
end
