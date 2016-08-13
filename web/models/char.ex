defmodule Exantenna.Char do
  use Exantenna.Web, :model
  use Exantenna.Es

  alias Exantenna.Toon
  alias Exantenna.Antenna

  @json_fields ~w(name alias kana romaji gyou height weight bust bracup waist hip blood birthday)
  @derive {Poison.Encoder, only: Enum.map(@json_fields, &(String.to_atom(&1)))}
  schema "chars" do
    has_many :thumbs, {"chars_thumbs", Exantenna.Thumb}, foreign_key: :assoc_id, on_delete: :delete_all
    has_many :scores, {"chars_scores", Exantenna.Score}, foreign_key: :assoc_id, on_replace: :delete

    many_to_many :tags, Exantenna.Tag, join_through: "chars_tags"
    many_to_many :toons, Exantenna.Toon, join_through: "toons_chars"

    field :name, :string
    field :kana, :string
    field :alias, :string
    field :romaji, :string
    field :gyou, :string

    field :height, :integer
    field :weight, :integer

    field :bust, :integer
    field :bracup, :string
    field :waist, :integer
    field :hip, :integer

    field :blood, :string
    field :birthday, Ecto.Date

    timestamps
  end

  @required_fields ~w(name)
  @optional_fields ~w(alias kana romaji gyou height weight bust bracup waist hip blood birthday)

  @relational_fields ~w(tags thumbs toons)a

  def full_relational_fields, do: @full_relational_fields
  @full_relational_fields @relational_fields

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
      from q in Antenna.query_all,
        limit: ^limit

    from q in query,
    preload: [toons: [antennas: ^antennas]]
  end

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> Exantenna.Ecto.Changeset.profile_changeset
    |> validate_required(~w(name)a)
    |> unique_constraint(:name, name: :chars_name_alias_index)
  end

  def item_changeset(%Antenna{toons: toons} = antenna, item \\ :invalid) do
    filters = Application.get_env(:exantenna, :char_filters)[:name]

    names =
      ConCache.get_or_store(:chars, "charnamealias:all", fn ->
        Enum.map Repo.all(__MODULE__), &([name: &1.name, alias: &1.alias || ""])
      end)
      |> Enum.filter(fn char ->
        Exantenna.Filter.right_name?(char, item, filters)
      end)
      |> Enum.map(fn char ->
        char[:name]
      end)

    chars =
      __MODULE__
      |> Exantenna.Ecto.Changeset.get_or_changeset(names)

    toons =
      Enum.map toons, fn toon ->
        put_assoc(change(toon), :chars, chars)
      end

    put_assoc(change(antenna), :toons, toons)
  end

  def aggs_changeset(model, params \\ :invalid) do
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
    ]
  end

  def esreindex, do: Es.Index.reindex __MODULE__, Repo.all(__MODULE__)

  def create_esindex(name \\ nil) do
    index = [type: estype, index: esindex(name)]
    Es.Schema.completion(index)
  end

end
