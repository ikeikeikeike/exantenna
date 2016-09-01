defmodule Exantenna.Thumb do
  use Exantenna.Web, :model

  @json_fields ~w(name src ext mime width height)
  @derive {Poison.Encoder, only: Enum.map(@json_fields, & String.to_atom(&1))}
  schema "thumbs" do
    field :assoc_id, :integer

    field :name, :string
    field :src, :string
    field :ext, :string
    field :mime, :string
    field :width, :integer
    field :height, :integer

    timestamps
  end

  @required_fields ~w(src)
  @optional_fields ~w(name ext mime width height)

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_required(~w(src)a)
  end
end
