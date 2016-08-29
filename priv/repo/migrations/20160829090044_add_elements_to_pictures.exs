defmodule Exantenna.Repo.Migrations.AddElementsToPictures do
  use Ecto.Migration

  def change do
    alter table(:pictures) do
      add :elements, :integer, default: 0
    end

    create index(:pictures, [:elements])
  end
end
