defmodule Connect.MixProject do
  use Mix.Project

  def project do
    [
      app: :connect,
      version: "0.1.0",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      preferred_cli_env: ["connect.test_coverage_doc": :test, "connect.acceptance_doc": :test],
      test_coverage: [ignore_modules: ignore_modules()]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Connect.Application, []},
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
      {:phoenix, "~> 1.5.8"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_dashboard, "~> 0.4"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:cassandrax,
       github: "rafbgarcia/cassandrax", ref: "881a4f83340237ee8fec709995f25bd9088aa59e"},
      {:snowflake, "~> 1.0.0"},
      {:absinthe_phoenix, "~> 2.0"},
      {:guardian, "~> 2.1"},
      {:bcrypt_elixir, "~> 2.0"},
      {:benchee, "~> 1.0", only: :dev},
      {:assertions, "~> 0.10", only: :test},
      {:mix_test_watch, "~> 1.0", only: :dev, runtime: false}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "connect.create_schema"],
      test_watch: ["test.watch --stale --max-failures 1"]
    ]
  end

  defp ignore_modules do
    [
      Mix.Tasks.Connect.CreateSchema,
      Mix.Tasks.Connect.RecreateSchema,
      Mix.Tasks.Connect.AcceptanceDoc,
      Mix.Tasks.Connect.TestCoverageDoc,
      Connect.Application,
      ConnectWeb,
      ConnectWeb.ErrorHelpers,
      ConnectWeb.ErrorView,
      ConnectWeb.Gettext,
      ConnectWeb.Guardia,
      ConnectWeb.LayoutView,
      ConnectWeb.PageController,
      ConnectWeb.PageView,
      ConnectWeb.Route,
      ConnectWeb.Telemetry,
      ConnectWeb.Schema.Types,
      ConnectWeb.Schema.ScalarTypes,
      ConnectWeb.Router,
      ConnectWeb.Guardian.Plug,
      ConnectWeb.Router.Helpers,
      Connect.Factory,
      Connect.FactorySequence,
      Connect.IntegrationCase,
      ConnectWeb.AbsintheCase,
      ConnectWeb.ChannelCase,
      ConnectWeb.ConnCase,
      ConnectWeb.Endpoint,
      ConnectWeb.Schema,
      ConnectWeb.Schema.Compiled,
      ConnectWeb.SubscriptionCase
    ]
  end
end
