defmodule ElhexDelivery.PostalCode.Store do
  use GenServer
  alias ElhexDelivery.PostalCode.DataParser

  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: :postal_code_store)
  end

  def init(_) do
    geolocation_data = DataParser.parse_data
    {:ok, geolocation_data}
  end

  # iex> ElhexDelivery.PostalCode.Store.start_link
  # iex> ElhexDelivery.PostalCode.Store.get_geolocation("94062")
  # {37.413691, -122.295343}

  def get_geolocation(postal_code) do
    GenServer.call(:postal_code_store, {:get_geolocation, postal_code})
  end

  # Callbacks

  def handle_call({:get_geolocation, postal_code}, _from, geolocation_data) do
    geolocation = Map.get(geolocation_data, postal_code)
    {:reply, geolocation, geolocation_data}
  end
end
