defmodule Exantenna.Penalty do
  use Exantenna.Web, :model

  schema "penalties" do
    field :assoc_id, :integer
    field :penalty, :string, default: "beginning"

    timestamps
  end

  @required_fields ~w(assoc_id)
  @optional_fields ~w(penalty)

  @penaltytypes ~w(beginning soft hard ban)

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
