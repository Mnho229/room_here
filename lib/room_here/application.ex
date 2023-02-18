defmodule RoomHere.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      RoomHere.Repo,
      # Start the Telemetry supervisor
      RoomHereWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: RoomHere.PubSub},
      # Start the Endpoint (http/https)
      RoomHereWeb.Endpoint
      # Start a worker by calling: RoomHere.Worker.start_link(arg)
      # {RoomHere.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RoomHere.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RoomHereWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
