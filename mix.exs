defmodule Keenmate.WebMultiselect.MixProject do
  use Mix.Project

  @version "1.0.0-rc.4"
  @source_url "https://github.com/keenmate/keen-web-multiselect"

  def project do
    [
      app: :keen_web_multiselect,
      version: @version,
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      docs: docs(),
      name: "Keenmate.WebMultiselect",
      source_url: @source_url,
      homepage_url: "https://keen-web-multiselect.keenmate.dev"
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:phoenix_live_view, "~> 1.0"},
      {:phoenix_html, "~> 4.1"},
      {:jason, "~> 1.4"},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false}
    ]
  end

  defp description do
    "Phoenix LiveView wrapper for the @keenmate/web-multiselect custom element " <>
      "(bundled JS+CSS, typed attrs for every documented option, optional LV hook)."
  end

  defp package do
    [
      maintainers: ["Keenmate"],
      licenses: ["MIT"],
      links: %{
        "Examples site" => "https://keen-web-multiselect.keenmate.dev",
        "GitHub" => @source_url,
        "Upstream web component" => "https://github.com/keenmate/web-multiselect"
      },
      files: ~w(lib priv guides ai AGENTS.md mix.exs README.md CHANGELOG.md LICENSE .formatter.exs),
      source_url: @source_url
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: [
        "README.md",
        "guides/theming.md",
        {"AGENTS.md", [title: "Using with AI agents"]},
        "CHANGELOG.md"
      ],
      source_ref: "v#{@version}",
      groups_for_extras: [
        Guides: ["guides/theming.md", "AGENTS.md"]
      ],
      groups_for_modules: [
        Components: [Keenmate.WebMultiselect.Components],
        Helpers: [Keenmate.WebMultiselect.OptionHelpers, Keenmate.WebMultiselect.FormHelpers]
      ]
    ]
  end
end
