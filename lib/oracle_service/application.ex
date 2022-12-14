defmodule OracleService.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  # The @impl true here denotes that the start function is implementing a
  # callback that was defined in the Application module
  # https://hexdocs.pm/elixir/main/Module.html#module-impl
  # This will aid the compiler to warn you when a implementaion is incorrect
  @impl true
  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: OracleService.Router, options: [port: 8080]}
    ]

    opts = [strategy: :one_for_one, name: OracleService.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
