defmodule Geotrace.Server do
  @name GT

  use GenServer, export: {:global, @name}
  require Logger

  @doc"""
  Start the server
  """
  def start_link(opts \\ []) do
   GenServer.start_link(__MODULE__, [], opts ++ [name: @name])
  end

  def init(_args), do: {:ok, []}

  @doc"""
  Spawn a linked process to perform geocoding, and sychronously return :ok
  The linked process will send the geocoded result back to sender process
  """
  def handle_call({:geocode, query}, from, state) do
    # log the server PID and the query
    Logger.debug("Geotrace Server (#{self() |> inspect()}) geocoding \"#{query}\"")

    # pattern match to get the sending process's PID
    {sender, _} = from

    # spawn a new process to handle the geocoding
    {:ok, linked_pid} = Task.start_link(fn () ->
      geocode_data = perform_geocoding!(query)
      send(sender, {:geocode_success, geocode_data})
    end)

    # reply with :ok
    {:reply, :ok, state ++ [{query, sender, linked_pid}]}
  end

  @doc"""
  Synchronously return history (the state of the server)
  """
  def handle_call(:history, _from, state), do: {:reply, state, state}

  defp perform_geocoding!(query) do
    {:ok, %{lat: lat, lon: lng, location: location}} = Geocoder.call(query)
    {lat, lng, location.city, location.country_code}
  end
end
