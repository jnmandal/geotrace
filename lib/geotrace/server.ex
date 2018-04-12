defmodule Geotrace.Server do
  @name GT

  use GenServer, export: {:global, @name}

  def start_link(opts \\ []) do
   GenServer.start_link(__MODULE__, [], name: @name)
  end

  def handle_call({:geocode, query}, from, state) do
    # pattern match to get the sending process's PID
    {sender, _} = from

    # spawn a new process to handle the geocoding
    Task.start_link(fn () ->
      geocode_data = perform_geocoding!(query)
      send(sender, {:geocode_success, geocode_data})
    end)

    # reply with :ok
    {:reply, :ok, state ++ [{query, sender}]}
  end

  def handle_call(:history, _from, state), do: {:reply, state, state}

  defp perform_geocoding!(query) do
    {:ok, %{lat: lat, lon: lng, location: location}} = Geocoder.call(query)
    {lat, lng, location.city, location.country_code}
  end

  defp random_sleep() do
    2000
    |> :rand.uniform()
    |> Process.sleep()
  end
end
