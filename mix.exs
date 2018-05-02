defmodule Slow.MixProject do
  use Mix.Project

  def project do
    [
      app: :slow,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Slow.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug, "~> 1.5.0"},
      {:cowboy, "~> 1.1.0"},
      {:earmark, "> 0.0.0"},
      {:mix_docker, "~> 0.5.0", runtime: false},
      {:distillery, "~> 1.5.0", runtime: false}
    ]
  end
end
