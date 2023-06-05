defmodule LiveViewIssue.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      LiveViewIssueWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: LiveViewIssue.PubSub},
      # Start the Endpoint (http/https)
      LiveViewIssueWeb.Endpoint,
      # Start a worker by calling: LiveViewIssue.Worker.start_link(arg)
      # {LiveViewIssue.Worker, arg}
      LiveViewIssue.User.Repo
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LiveViewIssue.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LiveViewIssueWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
