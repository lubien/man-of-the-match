defmodule Motm.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      MotmWeb.Telemetry,
      # Start the Ecto repository
      Motm.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Motm.PubSub},
      Motm.Bot.Supervisor,
      # Start the Endpoint (http/https)
      MotmWeb.Endpoint
      # Start a worker by calling: Motm.Worker.start_link(arg)
      # {Motm.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Motm.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MotmWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
