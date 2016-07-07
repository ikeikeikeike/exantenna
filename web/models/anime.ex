defmodule Exantenna.Anime do
  use Exantenna.Web, :model

  schema "animes" do
    has_one :thumb, {"animes_thumbs", Exantenna.Thumb}, foreign_key: :assoc_id
    has_many :characters, Exantenna.Character

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

    timestamps
  end

  @required_fields ~w(name)
  @optional_fields ~w(alias kana romaji gyou url author works release_date outline)

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def item_changeset(%Antenna{animes: _animes} = antenna, item \\ :invalid) do
    tags =
      Enum.map item["tags"], fn name ->
        case Repo.get_by(__MODULE__, name: name) do
          nil -> changeset(%__MODULE__{}, %{name: name})
          tag -> tag
        end
      end

    put_assoc(change(antenna), :tags, tags)
  end

end
