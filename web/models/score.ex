defmodule Exantenna.Score do
  use Exantenna.Web, :model

  schema "scores" do
    field :assoc_id, :integer
    field :name, :string
    field :count, :integer, default: 0

    timestamps
  end

  @required_fields ~w(assoc_id name)
  @optional_fields ~w(count)

  @names ~w(
    domain
    indaily  inweekly  inmonthly  inyearly  intotally
    outdaily outweekly outmonthly outyearly outtotally
  )

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
