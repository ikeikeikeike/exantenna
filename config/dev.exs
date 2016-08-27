use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :exantenna, Exantenna.Endpoint,
  http: [port: 4000],
  url: [host: "localhost", port: 9889],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin",
                     cd: Path.expand("../", __DIR__)]]

# Watch static and templates for browser reloading.
config :exantenna, Exantenna.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
# config :logger, :console, format: "[$level] $message\n"
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

config :quantum,
  # global?: true,
  cron: [
    # sitemaps_gen_sitemap: [
      # schedule: "43 */4 * * *",
      # task: "Sitemaps.gen_sitemap",
      # args: []
    # ],
    appear_aggs_tag: [
      schedule: "0 */5 * * *",
      task: "Exantenna.Builders.Appear.aggs",
      args: [Exantenna.Tag]
    ],
    appear_aggs_diva: [
      schedule: "10 */5 * * *",
      task: "Exantenna.Builders.Appear.aggs",
      args: [Exantenna.Diva]
    ],
    appear_aggs_char: [
      schedule: "20 */5 * * *",
      task: "Exantenna.Builders.Appear.aggs",
      args: [Exantenna.Char]
    ],
    appear_aggs_toon: [
      schedule: "30 */5 * * *",
      task: "Exantenna.Builders.Appear.aggs",
      args: [Exantenna.Toon]
    ],
    summary_aggs: [
      schedule: "40 */5 * * *",
      task: "Exantenna.Builders.Summary.aggs",
      args: []
    ],
    rss_feed_into: [
      schedule: "50 */5 * * *",
      task: "Exantenna.Builders.Rss.feed_into",
      args: []
    ]
  ]

import_config "sitemeta.dev.secret.exs"
import_config "dev.secret.exs"
