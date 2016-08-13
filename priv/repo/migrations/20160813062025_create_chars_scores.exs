defmodule Exantenna.Repo.Migrations.CreateCharsScores do
  use Ecto.Migration

  def change do
    create table(:chars_scores) do
      add :assoc_id, :integer

      add :name, :string
      add :count, :integer

      timestamps
    end
    create index(:chars_scores, [:assoc_id])

    create index(:chars_scores, [:name])
    create index(:chars_scores, [:count])

  end

end
