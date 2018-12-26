defmodule ElhexDelivery do
  use Application

  # Its executed when application starts:
  # iex> Application.start(:elhex_delivery)
  # {:error, {:already_started, :elhex_delivery}}

  def start(_type, _args) do
    ElhexDelivery.Supervisor.start_link
  end
end
