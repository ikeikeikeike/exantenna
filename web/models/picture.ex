defmodule Exantenna.Picture do
  use Exantenna.Web, :model

  schema "pictures" do
    has_one :antenna, Exantenna.Antenna

    has_many :thumbs, {"entries_thumbs", Exantenna.Thumb}, foreign_key: :assoc_id

    timestamps
  end

  @required_fields ~w()
  @optional_fields ~w()

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def item_changeset(%Antenna{picture: picture} = _antenna, item \\ :invalid) do
    picture
    |> changeset(%{thumbs: item[:pictures]})
    |> cast_assoc(:thumbs, required: true)
  end

end
