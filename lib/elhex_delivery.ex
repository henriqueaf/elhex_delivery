defmodule ElhexDelivery do
  @moduledoc """
  The Application main module, used to start the main
  Supervisor module ElhexDelivery.Supervisor.
  """

  use Application

  @doc """
  Executed when application starts. It starts the main Supervisor module.

  ## Examples
    iex> Application.start(:elhex_delivery)
    {:error, {:already_started, :elhex_delivery}}
  """

  def start(_type, _args) do
    ElhexDelivery.Supervisor.start_link
  end
end
