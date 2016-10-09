defmodule Exantenna.Mixfile do
  use Mix.Project

  def project do
    [app: :exantenna,
     version: version,
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     deps: deps]
  end

  defp version do
    v = "0.2.18"
    File.write! "VERSION", v
    v
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Exantenna, []},
      applications: [
        :phoenix, :phoenix_pubsub, :phoenix_html, :cowboy, :logger, :gettext, :phoenix_ecto, :postgrex,
        :ueberauth, :ueberauth_identity, :ueberauth_google,
        :timex, :timex_ecto, :tzdata,
        :comeonin,
        :bing_translator,
        :con_cache, :redix,
        :phoenix_html_simplified_helpers,
        :common_device_detector,
        :html_entities,
        :tributary,
        :phoenix_html_sanitizer,
        :simple_format,
        :guardian,
        :cors_plug,
        :tirexs,
        :rdtype,
        :mailgun,
        :quantum,
        :wakaway,
        :sitemap,
        :httpoison,
        :mogrify,
        :exsentry,
        :exkanji,
      ],
      included_applications: [
       :scrivener,
       :scrivener_html,
       :scrivener_ecto,
       :exromaji
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
      {:phoenix, "~> 1.2"},
      {:phoenix_pubsub, "~> 1.0"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_ecto, "~> 3.0"},
      {:phoenix_html, "~> 2.6"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:phoenix_html_simplified_helpers, "~> 0.6"},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      {:timex, "~> 2.2"},
      {:timex_ecto, "~> 1.1"},
      {:ueberauth, "~> 0.2"},
      {:ueberauth_google, "~> 0.2"},
      {:ueberauth_identity, "~> 0.2"},
      {:guardian, "~> 0.12"},
      {:comeonin, "~> 2.4"},
      {:mailgun, "~> 0.1"},
      {:redix, ">= 0.0.0"},
      {:bing_translator, "~> 0.3"},
      {:phoenix_html_sanitizer, "~> 1.0.0"},
      {:con_cache, "~> 0.11"},
      {:tirexs, "~> 0.8"},
      {:simple_format, "~> 0.1"},
      # {:public_suffix, "~> 0.4"},
      {:scrivener_html, github: "ikeikeikeike/scrivener_html", override: true},
      {:scrivener_ecto, "~> 1.0"},
      {:rdtype, github: "ikeikeikeike/rdtype"},
      {:common_device_detector, github: "ikeikeikeike/common_device_detector"},
      {:html_entities, "~> 0.3"},
      {:cors_plug, "~> 1.1"},
      {:tributary, github: "DavidAntaramian/tributary"},
      {:exrm, "~> 1.0"},
      {:quantum, "~> 1.7"},
      {:wakaway, "~> 0.5"},
      {:sitemap, ">= 0.0.0"},
      {:mogrify, "~> 0.4"},
      {:httpoison, "~> 0.9"},
      {:exsentry, "~> 0.7"},
      {:exkanji, "~> 0.3"},
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
