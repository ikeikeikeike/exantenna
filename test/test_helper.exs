ExUnit.start

Mix.Task.run "ecto.create", ~w(-r <%= application_module %>.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r <%= application_module %>.Repo --quiet)

Ecto.Adapters.SQL.Sandbox.mode(Exantenna.Repo, :manual)
