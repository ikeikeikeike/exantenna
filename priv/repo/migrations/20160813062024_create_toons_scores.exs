defmodule Exantenna.Repo.Migrations.CreateToonsScores do
  use Ecto.Migration

  def change do
    create table(:toons_scores) do
      add :assoc_id, :integer

      add :name, :string
      add :count, :integer

      timestamps
    end
    create index(:toons_scores, [:assoc_id])

    create index(:toons_scores, [:name])
    create index(:toons_scores, [:count])

  end

end
