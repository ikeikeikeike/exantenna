defmodule Exantenna.Repo.Migrations.AntennasAnimes do
  use Ecto.Migration

  def change do
    create table(:antennas_animes, primary_key: false) do
      add :antenna_id, references(:antennas)
      add :anime_id, references(:animes)
    end

    create index(:antennas_animes,  [:anime_id, :antenna_id], unique: true)
    create index(:antennas_animes,  [:antenna_id, :anime_id], unique: true)
  end

end
