defmodule Fluentdex.MixProject do
  use Mix.Project

  def project do
    [
      app: :fluentdex,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :ranch],
      mod: {Fluentdex, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ranch, "~> 1.7"},
      {:msgpax, "~> 2.0"}
    ]
  end
end
