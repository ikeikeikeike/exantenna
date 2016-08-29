defmodule Exantenna.Picture do
  use Exantenna.Web, :model
  alias Exantenna.Antenna

  schema "pictures" do
    has_one :antenna, Exantenna.Antenna
    has_many :thumbs, {"pictures_thumbs", Exantenna.Thumb}, foreign_key: :assoc_id, on_delete: :delete_all

    field :elements, :integer

    timestamps
  end

  @required_fields ~w()
  @optional_fields ~w(elements)

  def full_relational_fields, do: @full_relational_fields
  @full_relational_fields [
    :thumbs,
    antenna: Antenna.full_relational_fields
  ]

  @relational_fields [
    :thumbs,
    :antenna
  ]

  def query do
    from e in __MODULE__,
    preload: ^@relational_fields
  end

  def query_all do
    from e in __MODULE__,
    preload: ^@full_relational_fields
  end

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def item_changeset(%Antenna{picture: picture} = _antenna, item \\ :invalid) do
    picture
    |> changeset(%{elements: length(item["pictures"])})
    |> Exantenna.Ecto.Changeset.thumbs_changeset(item["pictures"])
  end

end
