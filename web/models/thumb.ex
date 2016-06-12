defmodule Exantenna.Thumb do
  use Exantenna.Web, :model

  schema "thumbs" do
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
  end
end
