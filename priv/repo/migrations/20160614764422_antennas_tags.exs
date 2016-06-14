defmodule Exantenna.Repo.Migrations.AntennasTags do
  use Ecto.Migration

  def change do
    create table(:antennas_tags, primary_key: false) do
      add :antenna_id, references(:antennas)
      add :tag_id, references(:tags)
    end
    create index(:antennas_tags,  [:antenna_id])
    create index(:antennas_tags,  [:tag_id])
    create index(:antennas_tags,  [:antenna_id, :tag_id], unique: true)

  end
end
