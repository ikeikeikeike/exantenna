defmodule Exantenna.Repo.Migrations.CreatePicture do
  use Ecto.Migration

  def change do
    create table(:pictures) do
      add :toon_id, references(:toons, on_delete: :nothing)

      timestamps
    end
    create index(:pictures, [:toon_id])

  end
end
