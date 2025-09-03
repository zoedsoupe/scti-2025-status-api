defmodule Service.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    port = System.get_env("PORT") || "4000"
    children = [{Bandit, plug: Service, port: String.to_integer(port)}]

    opts = [strategy: :one_for_one, name: Service.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
