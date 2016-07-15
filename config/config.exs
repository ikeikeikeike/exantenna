# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :exantenna, Exantenna.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "bk+quXQqzggSD8OlS2rMtSJW3KrYYPRhVMx1jev1tR03u3spLRHvFN6ZYV4P6/G3",
  render_errors: [view: Exantenna.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Exantenna.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :exantenna, MyApp.Gettext,
  default_locale: "ja"

config :exantenna, :redis,
  item: "redis://127.0.0.1:6379/1",
  feed: "redis://127.0.0.1:6379/6",
  imginfo: "redis://127.0.0.1:6379/9"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false

# for Ecto 2.0
config :exantenna,
  ecto_repos: [Exantenna.Repo]

import_config "toon_filters.secret.exs"
import_config "char_filters.secret.exs"
import_config "translate_filters.secret.exs"
import_config "ueberauth.secret.exs"
import_config "sitemeta.secret.exs"
import_config "mailgun.secret.exs"
