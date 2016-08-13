defmodule Exantenna.Repo.Migrations.CreateDivasScores do
  use Ecto.Migration

  def change do
    create table(:divas_scores) do
      add :assoc_id, :integer

      add :name, :string
      add :count, :integer

      timestamps
    end
    create index(:divas_scores, [:assoc_id])

    create index(:divas_scores, [:name])
    create index(:divas_scores, [:count])

  end

end
