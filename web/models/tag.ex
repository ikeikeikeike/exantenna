defmodule Exantenna.Tag do
  use Exantenna.Web, :model

  schema "tags" do
    field :name, :string
    field :kana, :string
    field :romaji, :string
    field :orig, :string
    field :gyou, :string

    has_one :thumb, {"tags_thumbs", Exantenna.Thumb}, foreign_key: :assoc_id

    many_to_many :entries, Exantenna.Entry, join_through: "antennas_tags"

    timestamps
  end

  @required_fields ~w(name)
  @optional_fields ~w(kana romaji orig gyou)

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end