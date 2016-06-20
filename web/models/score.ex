defmodule Exantenna.Score do
  use Exantenna.Web, :model

  schema "scores" do
    field :assoc_id, :integer
    field :name, :string
    field :count, :integer, default: 0

    timestamps
  end

  @required_fields ~w(assoc_id)
  @optional_fields ~w(name count)

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
