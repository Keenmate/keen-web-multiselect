defmodule TestApp.MixProject do
  use Mix.Project

  def project do
    [
      app: :test_app,
      version: "0.0.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      deps_path: "../deps",
      lockfile: "../mix.lock",
      listeners: [Phoenix.CodeReloader]
    ]
  end

  def application do
    [
      mod: {TestApp.Application, []},
      extra_applications: [:logger, :inets, :ssl]
    ]
  end

  defp deps do
    [
      {:keen_web_multiselect, path: ".."},
      {:phoenix, "~> 1.8"},
      {:phoenix_live_view, "~> 1.0"},
      {:phoenix_html, "~> 4.1"},
      {:jason, "~> 1.4"},
      {:bandit, "~> 1.5"},
      {:live_debugger, "~> 1.0", only: :dev}
    ]
  end
end
