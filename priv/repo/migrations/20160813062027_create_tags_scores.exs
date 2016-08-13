defmodule Exantenna.Repo.Migrations.CreateTagsScores do
  use Ecto.Migration

  def change do
    create table(:tags_scores) do
      add :assoc_id, :integer

      add :name, :string
      add :count, :integer

      timestamps
    end
    create index(:tags_scores, [:assoc_id])

    create index(:tags_scores, [:name])
    create index(:tags_scores, [:count])

  end
end
