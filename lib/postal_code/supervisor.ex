defmodule ElhexDelivery.PostalCode.Supervisor do
  use Supervisor
  alias ElhexDelivery.PostalCode.{Store, Navigator, Cache}

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  # It starts automatically ElhexDelivery.PostalCode.Store GenServer.
  # So you can call the ElhexDelivery.PostalCode.Store methods withour call start_link before:

  # iex> ElhexDelivery.PostalCode.Supervisor.start_link
  # iex> ElhexDelivery.PostalCode.Store.get_geolocation("94062")
  # {37.413691, -122.295343}

  def init(_) do
    children = [
      worker(Store, []),
      worker(Navigator, []),
      worker(Cache, [])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
