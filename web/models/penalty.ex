defmodule Exantenna.Penalty do
  use Exantenna.Web, :model

  schema "penalties" do
    field :assoc_id, :integer
    field :penalty, :string, default: "beginning"

    timestamps
  end

  @required_fields ~w(assoc_id)
  @optional_fields ~w(penalty)

  @penaltytypes ~w(beginning none soft hard ban)

  """
  - Insert one of item(page) into antenna model by kiked rss batch for every blogs in currently status.
  - Consider blog parts and dayly(hourly) score for inserting item.
  - work in progress
  """
  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  @penaltytypes
  |> Enum.each fn name ->
    def unquote(:"const_#{name}")() do
      unquote name
    end
  end

  def name_table(name) when is_bitstring(name), do: "#{name}s_penalties"
  def name_table(model), do: name_table(Exantenna.Ecto.Extractor.toname model)

end
