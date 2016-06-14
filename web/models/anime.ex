defmodule Exantenna.Anime do
  use Exantenna.Web, :model

  schema "animes" do
    field :name, :string
    field :alias, :string
    field :kana, :string
    field :romaji, :string
    field :gyou, :string

    field :url, :string
    field :author, :string
    field :works, :string

    field :outline, :string

    field :release_date, Ecto.DateTime

    has_one :thumb, {"animes_thumbs", Exantenna.Thumb}, foreign_key: :assoc_id

    timestamps
  end

  @required_fields ~w(name)
  @optional_fields ~w(alias kana romaji gyou url author works release_date outline)

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
