defmodule Exantenna.Toon do
  use Exantenna.Web, :model
  use Exantenna.Es

  alias Exantenna.Tag
  alias Exantenna.Char
  alias Exantenna.Antenna

  @json_fields ~w(name alias kana romaji gyou url aughor works outline release_date, chars)
  @derive {Poison.Encoder, only: Enum.map(@json_fields, &(String.to_atom(&1)))}
  schema "toons" do
    has_many :thumbs, {"toons_thumbs", Exantenna.Thumb}, foreign_key: :assoc_id, on_delete: :delete_all
    has_many :scores, {"toons_scores", Exantenna.Score}, foreign_key: :assoc_id, on_replace: :delete

    many_to_many :tags, Tag, join_through: "toons_tags"
    many_to_many :chars, Char, join_through: "toons_chars", on_replace: :delete
    many_to_many :antennas, Antenna, join_through: "antennas_toons"

    field :name, :string
    field :alias, :string
    field :kana, :string
    field :romaji, :string
    field :gyou, :string

    field :url, :string
    field :author, :string
    field :works, :string

    field :outline, :string

    field :release_date, Ecto.Date

    timestamps
  end

  @required_fields ~w(name)
  @optional_fields ~w(alias kana romaji gyou url author works release_date outline)

  @relational_fields ~w(antennas tags thumbs chars scores)a

  @full_relational_fields @relational_fields
  def full_relational_fields, do: @full_relational_fields

  def query do
    from e in __MODULE__,
    preload: ^@relational_fields
  end

  def query_all do
    from e in __MODULE__,
    preload: ^@full_relational_fields
  end

  def query_all(limit) do
    antennas =
      from q in Antenna.query_all(:index),
        order_by: [desc: q.id],
        limit: ^limit

    from q in query,
    preload: [antennas: ^antennas]
  end

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
        %{name: toon[:name]}
      end)

    toons =
      __MODULE__
      |> Exantenna.Ecto.Changeset.get_or_changeset(names)

    put_assoc(change(antenna), :toons, toons)
  end

  def score_changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> cast_assoc(:scores, required: true)
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
