defmodule Exantenna.Mixfile do
  use Mix.Project

  def project do
    [app: :exantenna,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     deps: deps]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Exantenna, []},
      applications: [
        :phoenix, :phoenix_html, :cowboy, :logger, :gettext, :phoenix_ecto, :postgrex,
        :ueberauth, :ueberauth_identity, :ueberauth_google,
        :timex, :timex_ecto, :tzdata,
        :comeonin,
      ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.1"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_ecto, "~> 3.0.0"},
      {:phoenix_html, "~> 2.6"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, github: "elixir-lang/gettext", override: true},
      {:cowboy, "~> 1.0"},
      {:timex, "~> 2.1"},
      {:timex_ecto, github: "bitwalker/timex_ecto"},
      {:ueberauth, "~> 0.2"},
      {:ueberauth_google, "~> 0.2"},
      {:ueberauth_identity, "~> 0.2"},
      {:guardian, "~> 0.12"},
      {:comeonin, "~> 2.4"},
      {:mailgun, "~> 0.1"},
      {:scrape, github: "Anonyfox/elixir-scrape"},
    ]
  end

  # Aliases are shortcut or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "test": ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
