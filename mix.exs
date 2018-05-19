defmodule Medialibrary.Mixfile do
  use Mix.Project

  def project do
    [
      app: :medialibrary,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Medialibrary.Application, []},
      extra_applications: [:logger, :runtime_tools, :httpotion]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.3.2"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:cowboy, "~> 1.0"},
      {:httpotion, "~> 3.1.0"},
      {:poison, "~> 3.1"},
      {:webpack_static_plug, "~> 0.2.0"},
      {:credo, "~> 0.5", only: [:dev, :test]},
      {:dogma, "~> 0.1", only: [:dev]},
      {:mox, "~> 0.3", only: :test},
      {:bypass, "~> 0.8", only: :test}
    ]
  end
end
