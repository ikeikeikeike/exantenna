defmodule Exantenna.Repo.Migrations.CreateAntennasScores do
  use Ecto.Migration

  def change do
    create table(:antennas_scores) do
      add :assoc_id, :integer

      add :name, :string
      add :count, :integer

      timestamps
    end
    create index(:antennas_scores, [:assoc_id])

    create index(:antennas_scores, [:name])
    create index(:antennas_scores, [:count])

  end
end
