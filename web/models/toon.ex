defmodule Exantenna.Toon do
  use Exantenna.Web, :model
  use Exantenna.Es

  alias Exantenna.Char
  alias Exantenna.Antenna

  schema "toons" do
    has_many :thumbs, {"toons_thumbs", Exantenna.Thumb},
      foreign_key: :assoc_id, on_delete: :delete_all

    many_to_many :tags, Exantenna.Tag, join_through: "toons_tags"
    many_to_many :chars, Exantenna.Toon, join_through: "toons_chars"

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
    |> Exantenna.Ecto.Changeset.rubytext_changeset
    |> validate_required(~w(name)a)
    |> validate_format(:url, ~r/^https?:\/\//)
    |> unique_constraint(:name, name: :toons_name_alias_index)
  end

  def item_changeset(%Antenna{toons: toons} = antenna, item \\ :invalid) do
    filters = Application.get_env(:exantenna, :toon_filters)[:title]

    names =
      ConCache.get_or_store(:toons, "toonnamealias:all", fn ->
        Enum.map Repo.all(__MODULE__), &([name: &1.name, alias: &1.alias])
      end)
      |> Enum.filter(fn toon ->
        Exantenna.Filter.right_name?(toon, item, filters)
      end)
      |> Enum.map(fn toon ->
        toon[:name]
      end)

    toons =
      __MODULE__
      |> Exantenna.Ecto.Changeset.get_or_changeset(names)

    put_assoc(change(antenna), :toons, toons)
  end

  # for autocomplete below.

  def essearch(word), do: essearch(word, [])
  def essearch("", options), do: essearch(nil, options)
  def essearch(word, options) do
    result = Es.Q.completion(word, esindex)

    case result do
      {_, _, map} -> map
      r -> r
    end
  end

  def search_data(model) do
    [
      id: model.id,
      name: model.name,
      kana: model.kana,
      alias: model.alias,
      romaji: model.romaji,
      # tags: [],
      # chars: [],
    ]
  end

  def esreindex, do: Es.Index.reindex __MODULE__, Repo.all(__MODULE__)

  def create_esindex(name \\ nil) do
    index = [type: estype, index: esindex(name)]
    Es.Schema.completion(index)
  end

end
