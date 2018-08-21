defmodule ElhexDelivery.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  # Its going to monitor all other supervisors. This is the MAIN SUPERVISOR

  def init(_) do
    children = [
      supervisor(ElhexDelivery.PostalCode.Supervisor, [])
    ]

    supervise(children, strategy: :one_for_all)
  end
end
