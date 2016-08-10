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
      worker(ConCache, [[ttl_check: :timer.seconds(666), ttl: :timer.seconds(60 * 60 * 24 * 30)], [name: :translate]], id: :exantenna_translate_cache),
      worker(ConCache, [[ttl_check: :timer.seconds(555), ttl: :timer.seconds(60 * 60 * 24 * 15)], [name: :es]], id: :exantenna_es_cache),
      worker(ConCache, [[ttl_check: :timer.seconds(499), ttl: :timer.seconds(60 * 60 * 24 * 3)], [name: :chars]], id: :exantenna_chars_cache),
      worker(ConCache, [[ttl_check: :timer.seconds(488), ttl: :timer.seconds(60 * 60 * 24 * 3)], [name: :toons]], id: :exantenna_toons_cache),
      worker(ConCache, [[ttl_check: :timer.seconds(477), ttl: :timer.seconds(60 * 60 * 24 * 3)], [name: :divas]], id: :exantenna_divas_cache),
      worker(ConCache, [[ttl_check: :timer.seconds(466), ttl: :timer.seconds(60 * 60 * 24 * 3)], [name: :tags]], id: :exantenna_tags_cache),
      worker(ConCache, [[ttl_check: :timer.seconds(454), ttl: :timer.seconds(60 * 60 * 24 * 2)], [name: :common]], id: :exantenna_common_cache),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Exantenna.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Exantenna.Endpoint.config_change(changed, removed)
    :ok
  end
end
