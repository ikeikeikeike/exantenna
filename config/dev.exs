use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :exantenna, Exantenna.Endpoint,
  http: [port: 4000],
  url: [host: "localhost", port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin",
                     cd: Path.expand("../", __DIR__)]]

# Watch static and templates for browser reloading.
config :exantenna, Exantenna.Endpoint,
  live_reload: [
    patterns: [
      # ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
# config :logger, :console, format: "[$level] $message\n"
# config :logger, level: :info
config :logger, :console,
  format: "$date $time $metadata[$level]$levelpad$message\n",
  metadata: [:user_id, :request_id, :application, :module, :file, :line]

# Set a higher stacktrace during development.
# Do not configure such in production as keeping
# and calculating stacktraces is usually expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :exantenna, Exantenna.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "exantenna_dev",
  hostname: "localhost",
  pool_size: 10,
  timeout: 300000  # XXX: For Develop
  # ownership_timeout: 300000

config :sitemap, [
  host: "http://127.0.0.1",
  public_path: "",
  files_path: "log/",
]

import_config "sitemeta.dev.secret.exs"
import_config "dev.secret.exs"
