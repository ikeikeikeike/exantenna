defmodule Exantenna do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Start the endpoint when the application starts
      supervisor(Exantenna.Endpoint, []),
      # Start the Ecto repository
      supervisor(Exantenna.Repo, []),
      # Here you could define other workers and supervisors as children
      # worker(Exantenna.Worker, [arg1, arg2, arg3]),
      worker(ConCache, [[ttl_check: :timer.seconds(66), ttl: :timer.seconds(60 * 60 * 24 * 3)], [name: :translate]], id: :exantenna_translate_cache),
      worker(ConCache, [[ttl_check: :timer.seconds(55), ttl: :timer.seconds(60 * 60 * 24 * 1)], [name: :es]], id: :exantenna_es_cache),
      worker(ConCache, [[ttl_check: :timer.seconds(49), ttl: :timer.seconds(60 * 60 * 24 * 1)], [name: :chars]], id: :exantenna_chars_cache),
      worker(ConCache, [[ttl_check: :timer.seconds(48), ttl: :timer.seconds(60 * 60 * 24 * 1)], [name: :toons]], id: :exantenna_toons_cache),
      worker(ConCache, [[ttl_check: :timer.seconds(47), ttl: :timer.seconds(60 * 60 * 24 * 1)], [name: :divas]], id: :exantenna_divas_cache),
      worker(ConCache, [[ttl_check: :timer.seconds(46), ttl: :timer.seconds(60 * 60 * 24 * 1)], [name: :tags]], id: :exantenna_tags_cache),
      worker(ConCache, [[ttl_check: :timer.seconds(45), ttl: :timer.seconds(60 * 60 * 17 * 1)], [name: :common]], id: :exantenna_common_cache),
      worker(ConCache, [[ttl_check: :timer.seconds(44), ttl: :timer.seconds(60 * 60 * 24 * 1)], [name: :encjson]], id: :exantenna_encjson_cache),
      worker(ConCache, [[ttl_check: :timer.seconds(10), ttl: :timer.seconds(60 * 2)], [name: :apiv1]], id: :exantenna_apiv1_cache),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Exantenna.Supervisor]
    Supervisor.start_link(children, opts)

    # for error
    # Logger.add_backend(ExSentry.LoggerBackend)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Exantenna.Endpoint.config_change(changed, removed)
    :ok
  end
end
