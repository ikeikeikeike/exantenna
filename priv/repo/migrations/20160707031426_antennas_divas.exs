defmodule Exantenna.Repo.Migrations.AntennasDivas do
  use Ecto.Migration

  def change do
    create table(:antennas_divas, primary_key: false) do
      add :antenna_id, references(:antennas)
      add :diva_id, references(:divas)
    end
    create index(:antennas_divas,  [:diva_id, :antenna_id], unique: true)
    create index(:antennas_divas,  [:antenna_id, :diva_id], unique: true)

  end
end
