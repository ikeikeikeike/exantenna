defmodule Exantenna.Repo.Migrations.CreateEntriesScores do
  use Ecto.Migration

  def change do
    create table(:entries_scores) do
      add :assoc_id, :integer
      add :name, :string
      add :count, :integer

      timestamps
    end
    create index(:entries_scores, [:assoc_id])
    create index(:entries_scores, [:name])
    create index(:entries_scores, [:count])

  end
end
