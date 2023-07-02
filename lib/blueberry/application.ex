defmodule Blueberry.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      BlueberryWeb.Telemetry,
      # Start the Ecto repository
      Blueberry.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Blueberry.PubSub},
      # Start Finch
      {Finch, name: Blueberry.Finch},
      # Start the Endpoint (http/https)
      BlueberryWeb.Endpoint
      # Start a worker by calling: Blueberry.Worker.start_link(arg)
      # {Blueberry.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Blueberry.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BlueberryWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
