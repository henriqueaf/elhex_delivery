defmodule ElhexDelivery.PostalCode.Navigator do
  @moduledoc """
  The Navigator module responsible to measure distance between postal codes.
  """

  use GenServer
  alias :math, as: Math
  alias ElhexDelivery.PostalCode.{Store, Cache}

  # @radius 6371 #km
  @radius 3959 #miles

  def start_link do
    GenServer.start_link(__MODULE__, [], name: :postal_code_navigator)
  end

  def init(_) do
    {:ok, []}
  end

  @doc """
  Measure distance between postal codes.

  ## Examples
    iex> ElhexDelivery.PostalCode.Navigator.start_link
    iex> ElhexDelivery.PostalCode.Navigator.get_distance(94062, 94104)
    26.75
  """
  def get_distance(from, to) do
    GenServer.call(:postal_code_navigator, {:get_distance, from, to})
  end

  #Callbacks

  def handle_call({:get_distance, from, to}, _from, state) do
    distance = do_get_distance(from, to)
    {:reply, distance, state}
  end

  defp do_get_distance(from, to) do
    from = format_postal_code(from)
    to = format_postal_code(to)

    case Cache.get_distance(from, to) do
      nil ->
        try do
          {lat1, long1} = get_geolocation(from)
          {lat2, long2} = get_geolocation(to)

          distance = calculate_distance({lat1, long1}, {lat2, long2})
          Cache.set_distance(from, to, distance)
          distance
        rescue
          e in RuntimeError -> e.message
        end
      distance -> distance
    end
  end

  defp get_geolocation(postal_code) do
    case Store.get_geolocation(postal_code) do
      nil ->
        error = "postal_code not found, received: (#{postal_code})"
        raise RuntimeError, error
      geolocation -> geolocation
    end
  end

  defp format_postal_code(postal_code) when is_binary(postal_code), do: postal_code
  defp format_postal_code(postal_code) when is_integer(postal_code) do
    postal_code = Integer.to_string(postal_code)
    format_postal_code(postal_code)
  end
  defp format_postal_code(postal_code) do
    error = "unespected `postal_code`, received: (#{inspect(postal_code)})"
    raise ArgumentError, error
  end

  # It uses the Great Circle Distance calculation
  defp calculate_distance({lat1, long1}, {lat2, long2}) do
    lat_diff = degrees_to_radians(lat2 - lat1)
    long_diff = degrees_to_radians(long2 - long1)

    lat1 = degrees_to_radians(lat1)
    lat2 = degrees_to_radians(lat2)

    cos_lat1 = Math.cos(lat1)
    cos_lat2 = Math.cos(lat2)

    sin_lat_diff_sq = Math.sin(lat_diff / 2) |> Math.pow(2)
    sin_long_diff_sq = Math.sin(long_diff / 2) |> Math.pow(2)

    a = sin_lat_diff_sq + (cos_lat1 * cos_lat2 * sin_long_diff_sq)
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))

    @radius * c |> Float.round(2)
  end

  defp degrees_to_radians(degrees) do
    degrees * (Math.pi / 180)
  end
end
