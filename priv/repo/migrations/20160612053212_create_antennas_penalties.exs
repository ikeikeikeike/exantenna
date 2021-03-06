defmodule Exantenna.Repo.Migrations.CreateAntennasPenalties do
  use Ecto.Migration

  def change do
    create table(:antennas_penalties) do
      add :assoc_id, :integer
      add :penalty, :string

      timestamps
    end

    create index(:antennas_penalties, [:assoc_id])
    create index(:antennas_penalties, [:penalty])
  end

end
