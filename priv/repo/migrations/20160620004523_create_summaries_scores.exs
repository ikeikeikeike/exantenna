defmodule Exantenna.Repo.Migrations.CreateSummariesScores do
  use Ecto.Migration

  def change do
    create table(:summaries_scores) do
      add :assoc_id, :integer
      add :name, :string
      add :count, :integer

      timestamps
    end
    create index(:summaries_scores, [:assoc_id])
    create index(:summaries_scores, [:name])
    create index(:summaries_scores, [:count])
  end
end
