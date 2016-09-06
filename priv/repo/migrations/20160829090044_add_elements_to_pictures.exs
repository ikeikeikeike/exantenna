defmodule Exantenna.Repo.Migrations.AddElementsToPictures do
  use Ecto.Migration

  def change do
    alter_if_not_exists table(:pictures) do
      add :elements, :integer, default: 0
    end

    create_if_not_exists index(:pictures, [:elements])
  end
end
