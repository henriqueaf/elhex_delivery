defmodule ElhexDelivery.PostalCode.DataParser do
  @postal_codes_file_path "data/2017_Gaz_zcta_national.txt"

  def parse_data do
    [_header | data_rows] = File.read!(@postal_codes_file_path) |> String.split("\n")

    data_rows
    |> Enum.map(&String.split(&1, "\t"))
    |> Enum.filter(&data_row?(&1))
    |> Enum.map(&parse_data_columns(&1))
    |> Enum.map(fn(row) ->
      [postal_code, latitude, longitude] = row

      latitude = latitude |> String.replace(" ", "") |> String.to_float
      longitude = longitude |> String.replace(" ", "") |> String.to_float

      {postal_code, {latitude, longitude}}
    end)
    |> Enum.into(%{})
  end

  defp data_row?(row) do
    case row do
      [_postal_code, _, _, _, _, _latitude, _longitude] -> true
      _ -> false
    end
  end

  defp parse_data_columns(row) do
    [postal_code, _, _, _, _, latitude, longitude] = row
    [postal_code, latitude, longitude]
  end
end
