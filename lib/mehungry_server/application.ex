defmodule MehungryServer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
       {ConCache,
       [
         name: :user_recipes,
         ttl_check_interval: 2_000,
         global_ttl: 2_000,
         touch_on_read: true
       ]},
      # Start the Ecto repository
      MehungryServer.Repo,
      # Start the endpoint when the application starts
      MehungryServerWeb.Endpoint,
      MehungryServerWeb.Telemetry
      # Starts a worker by calling: MehungryServer.Worker.start_link(arg)
      # {MehungryServer.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MehungryServer.Supervisor]
    Supervisor.start_link(children, opts)

  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    MehungryServerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
