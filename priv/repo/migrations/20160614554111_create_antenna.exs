defmodule Exantenna.Repo.Migrations.CreateAntenna do
  use Ecto.Migration

  def change do
    create table(:antennas) do
      add :metadata_id, references(:metadatas, on_delete: :nothing)
      add :blog_id, references(:blogs, on_delete: :nothing)
      add :entry_id, references(:entries, on_delete: :nothing)
      add :video_id, references(:videos, on_delete: :nothing)
      add :picture_id, references(:pictures, on_delete: :nothing)
      add :summary_id, :integer

      timestamps
    end
    create index(:antennas, [:metadata_id])
    create index(:antennas, [:blog_id])
    create index(:antennas, [:entry_id])
    create index(:antennas, [:video_id])
    create index(:antennas, [:picture_id])
    create index(:antennas, [:summary_id])

  end
end
