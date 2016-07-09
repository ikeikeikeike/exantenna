defmodule Exantenna.Repo.Migrations.AntennasToons do
  use Ecto.Migration

  def change do
    create table(:antennas_toons, primary_key: false) do
      add :antenna_id, references(:antennas)
      add :toon_id, references(:toons)
    end

    create index(:antennas_toons,  [:toon_id, :antenna_id], unique: true)
    create index(:antennas_toons,  [:antenna_id, :toon_id], unique: true)
  end

end
