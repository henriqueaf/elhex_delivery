defmodule ElhexDelivery.PostalCode.DataParserTest do
  use ExUnit.Case
  alias ElhexDelivery.PostalCode.DataParser

  doctest ElhexDelivery.PostalCode.DataParser

  test "parse_date" do
    geolocation_data = DataParser.parse_data
    {latitude, longitude} = Map.get(geolocation_data, "94062")

    assert is_float(latitude)
    assert is_float(longitude)
  end
end
