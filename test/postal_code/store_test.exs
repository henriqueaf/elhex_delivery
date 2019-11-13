defmodule ElhexDelivery.PostalCode.StoreTest do
  use ExUnit.Case
  alias ElhexDelivery.PostalCode.Store
  doctest ElhexDelivery.PostalCode.Store

  test "get_geolocation" do
    # you can run tests without call start_lik because the application module already started all supervisors and GenServer's
    # Store.start_link
    {latitude, longitude} = Store.get_geolocation("94062")

    assert is_float(latitude)
    assert is_float(longitude)
  end
end
