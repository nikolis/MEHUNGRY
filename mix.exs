defmodule MehungryServer.MixProject do
  use Mix.Project

  def project do
    [
      app: :mehungry_server,
      version: "0.1.0",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers() ++ [:phoenix_swagger],
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test, "coveralls.detail": :test, "coveralls.post": :test],
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {MehungryServer.Application, []},
      extra_applications: [:logger, :runtime_tools]
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
      {:phoenix, "~> 1.5.5"},
      {:credo, "~> 1.5.0-rc.2", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.10", only: :test},
      {:con_cache, "~> 0.13.1"},
      {:cors_plug, "~> 1.5"},
      {:phoenix_pubsub, "~> 2.0"},    
      {:phoenix_ecto, "~> 4.0"},      
      {:comeonin, "~> 4.1"},
      {:bcrypt_elixir, "~> 1.0"},
      {:phoenix_swagger, "~> 0.8"},
      {:ex_json_schema, "~> 0.5"}, 
      {:guardian, "~> 1.0"},
      {:pbkdf2_elixir, "~> 0.12"},    
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.11"},     
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.13.0"},
      {:phoenix_live_dashboard, "~> 0.2"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:httpoison, "~> 1.2"},
      {:poison, "~> 3.1"},
      {:plug_cowboy, "~> 2.1"},
      {:telemetry_metrics, "~> 0.4"}, 
      {:telemetry_poller, "~> 0.4"},

    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
