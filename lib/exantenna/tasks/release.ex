defmodule :release_tasks do
  def migrate do
    {:ok, _} = Application.ensure_all_started(:exantenna)

    path = Application.app_dir(:exantenna, "priv/repo/migrations")

    Ecto.Migrator.run(Exantenna.Repo, path, :up, all: true)

    :init.stop()
  end
end
