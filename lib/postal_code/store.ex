defmodule ElhexDelivery.PostalCode.Store do
  @moduledoc """
  The Store module responsible to execute searches
  on geolocation and postal codes.
  """

  use GenServer
  alias ElhexDelivery.PostalCode.DataParser

  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: :postal_code_store)
  end

  def init(_) do
    geolocation_data = DataParser.parse_data
    {:ok, geolocation_data}
  end

  @doc """
  Executed when application starts. It starts the main Supervisor module.

  ## Examples
    iex> ElhexDelivery.PostalCode.Store.start_link # Already started when application starts. Just for explanation.
    iex> ElhexDelivery.PostalCode.Store.get_geolocation("94062")
    {37.413691, -122.295343}
  """
  def get_geolocation(postal_code) do
    GenServer.call(:postal_code_store, {:get_geolocation, postal_code})
  end

  # Callbacks

  def handle_call({:get_geolocation, postal_code}, _from, geolocation_data) do
    geolocation = Map.get(geolocation_data, postal_code)
    {:reply, geolocation, geolocation_data}
  end
end
