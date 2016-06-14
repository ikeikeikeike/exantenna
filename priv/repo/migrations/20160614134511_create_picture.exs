defmodule Exantenna.Repo.Migrations.CreatePicture do
  use Ecto.Migration

  def change do
    create table(:pictures) do
      add :anime_id, references(:animes, on_delete: :nothing)

      timestamps
    end
    create index(:pictures, [:anime_id])

  end
end
