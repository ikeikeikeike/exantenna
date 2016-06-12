defmodule Exantenna.Repo.Migrations.BlogsPenalties do
  use Ecto.Migration

  def change do
    create table(:blogs_penalties) do
      add :assoc_id, :integer
      add :penalty, :string

      timestamps
    end

    create index(:blogs_penalties, [:assoc_id])
    create index(:blogs_penalties, [:penalty])
    create index(:blogs_penalties, [:assoc_id, :penalty])
  end
end
