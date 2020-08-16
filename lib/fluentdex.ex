defmodule Fluentdex do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      Fluentdex.Server
    ]

    opts = [strategy: :one_for_one, name: Fluentdex.Server]
    Supervisor.start_link(children, opts)
  end
end
