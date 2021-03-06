use Mix.Config

# For production, we configure the host to read the PORT
# from the system environment. Therefore, you will need
# to set PORT=80 before running your server.
#
# You should also configure the url host to something
# meaningful, we use this information when generating URLs.
#
# Finally, we also include the path to a manifest
# containing the digested version of static files. This
# manifest is generated by the mix phoenix.digest task
# which you typically run after static files are built.
myhost = String.replace(File.read!("config/myhost"), "\n", "")

  # http: [port: {:system, "PORT"}],
config :exantenna, Exantenna.Endpoint,
  http: [port: 5700],
  url: [host: myhost, port: 80],
  cache_static_manifest: "priv/static/manifest.json",
  server: true


# Do not print debug messages in production
# config :logger, level: :info
config :logger, level: :warn
# config :logger, level: :info,
  # format: "$date $time $metadata[$level]$levelpad$message\n",
  # metadata: [:user_id, :request_id, :application, :module, :file, :line]

# ## SSL Support
#
# To get SSL working, you will need to add the `https` key
# to the previous section and set your `:url` port to 443:
#
#     config :exantenna, Exantenna.Endpoint,
#       ...
#       url: [host: "example.com", port: 443],
#       https: [port: 443,
#               keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#               certfile: System.get_env("SOME_APP_SSL_CERT_PATH")]
#
# Where those two env variables return an absolute path to
# the key and cert in disk or a relative path inside priv,
# for example "priv/ssl/server.key".
#
# We also recommend setting `force_ssl`, ensuring no data is
# ever sent via http, always redirecting to https:
#
#     config :exantenna, Exantenna.Endpoint,
#       force_ssl: [hsts: true]
#
# Check `Plug.SSL` for all available options in `force_ssl`.

# ## Using releases
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start the server for all endpoints:
#
#     config :phoenix, :serve_endpoints, true
#
# Alternatively, you can configure exactly which server to
# start per endpoint:
#
#     config :exantenna, Exantenna.Endpoint, server: true
#
# You will also need to set the application root to `.` in order
# for the new static assets to be served after a hot upgrade:
#
#     config :exantenna, Exantenna.Endpoint, root: "."

# Finally import the config/prod.secret.exs
# which should be versioned separately.

config :quantum,
  # global?: true,
  cron: [
    sitemaps_gen_sitemap: [
      schedule: "5 1,4,7,22 * * *", # UTC
      task: "Exantenna.Sitemap.gen_sitemap",
      args: []
    ],
    appear_aggs_tag: [
      schedule: "15 5 * * *", # every around AM05 UTC
      task: "Exantenna.Builders.Appear.aggs",
      args: [Exantenna.Tag]
    ],
    appear_aggs_diva: [
      schedule: "25 5 * * *", # every around AM05 UTC
      task: "Exantenna.Builders.Appear.aggs",
      args: [Exantenna.Diva]
    ],
    appear_aggs_char: [
      schedule: "35 5 * * *", # every around AM05 UTC
      task: "Exantenna.Builders.Appear.aggs",
      args: [Exantenna.Char]
    ],
    appear_aggs_toon: [
      schedule: "45 5 * * *", # every around AM05 UTC
      task: "Exantenna.Builders.Appear.aggs",
      args: [Exantenna.Toon]
    ],
    summary_aggs: [
      schedule: "55 * * * *",
      task: "Exantenna.Builders.Summary.aggs",
      args: []
    ],
    rss_feed_into_everything: [
      schedule: "50 */5 * * *",
      task: "Exantenna.Builders.Rss.feed_into",
      args: [:everything]
    ],
    rss_feed_into_begginer: [
      schedule: "40 */4 * * *",
      task: "Exantenna.Builders.Rss.feed_into",
      args: [:begginer]
    ],
    rss_feed_into_no_penalty: [
      schedule: "30 */3 * * *",
      task: "Exantenna.Builders.Rss.feed_into",
      args: [:no_penalty]  # :none
    ],
    # Unkicking numbers(like primes): 1,7,11,13,17,19,23
    rss_feed_into_todays_access_primes: [
      schedule: "20 1,7,11,13,17,19,23 * * *",
      task: "Exantenna.Builders.Rss.feed_into",
      args: [:no_penalty]
      # args: [:begginer]
      # args: [:todays_access]  # TODO: Gonna be changing to :todays_access when this system are accessed from many blogs.
    ],
    rss_feed_into_todays_access: [
      schedule: "10 */2 * * *",
      task: "Exantenna.Builders.Rss.feed_into",
      args: [:todays_access]
    ],
    reindex_evolve: [
      schedule: "18 1 * * *", # Every AM01:18 UTC
      task: "Exantenna.Builders.Reindex.evolve",
      args: []
    ],
    penalty_up: [
      schedule: "8 22 * * *", # Every 22:08 UTC
      task: "Exantenna.Builders.Penalty.penalty",
      args: [:up]
    ],
    penalty_down: [
      schedule: "18 16,22 * * *", # Every 16:18,22:18 UTC
      task: "Exantenna.Builders.Penalty.penalty",
      args: [:down]
    ],
    # penalty_ban: [
    #   schedule: "28 22 * * 6", # Every week 22:28 UTC
    #   task: "Exantenna.Builders.Penalty.penalty",
    #   args: [:ban]
    # ],
    # penalty_left: [
    #   schedule: "38 22 * * 6", # Every week 22:38 UTC
    #   task: "Exantenna.Builders.Penalty.penalty",
    #   args: [:left]
    # ],
    penalty_nothing: [
      schedule: "48 22 * * *", # Every 22:48 UTC
      task: "Exantenna.Builders.Penalty.penalty",
      args: [:nothing]
    ],
    penalty_begin: [
      schedule: "58 * * * *", # Every 58 min.
      task: "Exantenna.Builders.Penalty.penalty",
      args: [:begin]
    ],
    translation_diva: [
      schedule: "13 23 * * 5", # Every week 23:13 UTC
      task: "Exantenna.Builders.Translation.diva",
      args: []
    ],
    translation_toon: [
      schedule: "26 23 * * 5", # Every week 23:26 UTC
      task: "Exantenna.Builders.Translation.toon",
      args: []
    ],
    translation_char: [
      schedule: "39 23 * * 5", # Every week 23:39 UTC
      task: "Exantenna.Builders.Translation.char",
      args: []
    ],
    translation_tag: [
      schedule: "52 23 * * 5", # Every week 23:52 UTC
      task: "Exantenna.Builders.Translation.tag",
      args: []
    ]
  ]

config :sitemap, [
  host: "http://#{myhost}",
  public_path: "",
  files_path: "static/",
]

import_config "sitemeta.prod.secret.exs"
import_config "prod.secret.exs"
