defmodule Exantenna.Tag do
  use Exantenna.Web, :model
  alias Exantenna.Antenna

  schema "tags" do
    field :name, :string
    field :kana, :string
    field :romaji, :string
    field :orig, :string
    field :gyou, :string

    has_one :thumb, {"tags_thumbs", Exantenna.Thumb}, foreign_key: :assoc_id

    many_to_many :antennas, Exantenna.Entry, join_through: "antennas_tags"

    timestamps
  end

  @required_fields ~w(name)
  @optional_fields ~w(kana romaji orig gyou)

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def item_changeset(%Antenna{tags: _tags} = antenna, item \\ :invalid) do
    # TODO: find_or_create
    tags =
      Enum.map item["tags"], fn name ->
        changeset(%__MODULE__{}, %{name: name})
      end

    put_assoc(change(antenna), :tags, tags)
  end

end
