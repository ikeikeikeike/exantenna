ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Exantenna.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Exantenna.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Exantenna.Repo)

