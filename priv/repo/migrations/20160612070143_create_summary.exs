defmodule Exantenna.Repo.Migrations.CreateSummary do
  use Ecto.Migration

  def change do
    create table(:summaries) do
      add :sort, :integer

      timestamps
    end
    create index(:summaries, [:sort])

  end
end
