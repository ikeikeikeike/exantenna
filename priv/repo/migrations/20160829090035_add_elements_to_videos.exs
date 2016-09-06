defmodule Exantenna.Repo.Migrations.AddElementsToVideos do
  use Ecto.Migration

  def change do
    alter table(:videos) do
      add :elements, :integer, default: 0
    end

    create_if_not_exists index(:videos, [:elements])
  end

end
