defmodule Exantenna.Repo.Migrations.CreateDivasScores do
  use Ecto.Migration

  def change do
    create table(:divas_scores, primary_key: false) do
      add :assoc_id, :integer, primary_key: true
      add :name, :string, primary_key: true

      add :count, :integer

      timestamps
    end
    create unique_index(:divas_scores, [:assoc_id, :name], name: :divas_scores_assoc_id_name_index)
    create index(:divas_scores, [:count])
  end

end
