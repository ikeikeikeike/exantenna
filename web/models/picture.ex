defmodule Exantenna.Picture do
  use Exantenna.Web, :model
  alias Exantenna.Antenna

  schema "pictures" do
    has_one :antenna, Exantenna.Antenna
    has_many :thumbs, {"pictures_thumbs", Exantenna.Thumb}, foreign_key: :assoc_id, on_delete: :delete_all

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
    |> changeset
    |> Exantenna.Ecto.Changeset.thumbs_changeset(item["pictures"])
  end

end
