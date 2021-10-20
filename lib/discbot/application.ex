defmodule Discbot.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Discbot.Consumer
      # Starts a worker by calling: Discbot.Worker.start_link(arg)
      # {Discbot.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Discbot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
