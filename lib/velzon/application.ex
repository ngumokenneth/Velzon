defmodule Velzon.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      VelzonWeb.Telemetry,
      Velzon.Repo,
      {DNSCluster, query: Application.get_env(:velzon, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Velzon.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Velzon.Finch},
      # Start a worker by calling: Velzon.Worker.start_link(arg)
      # {Velzon.Worker, arg},
      # Start to serve requests, typically the last entry
      VelzonWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Velzon.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    VelzonWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
