defmodule Exantenna.Diva do
  use Exantenna.Web, :model
  use Exantenna.Es

  alias Exantenna.Thumb
  alias Exantenna.Antenna

  @json_fields ~w(name alias kana romaji gyou height weight bust bracup waist hip blood birthday)
  @derive {Poison.Encoder, only: Enum.map(@json_fields, &(String.to_atom(&1)))}
  schema "divas" do
    has_many :thumbs, {"divas_thumbs", Thumb}, foreign_key: :assoc_id, on_delete: :delete_all
    has_many :scores, {"divas_scores", Exantenna.Score}, foreign_key: :assoc_id
    many_to_many :antennas, Antenna, join_through: "antennas_divas"

    field :name, :string
    field :alias, :string
    field :kana, :string
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
  @optional_fields ~w(
    alias kana romaji gyou height weight bust bracup
    waist hip blood birthday
  )

  @relational_fields ~w(antennas thumbs)a

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
    preload: [antennas: ^antennas]
  end

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> Exantenna.Ecto.Changeset.profile_changeset
    |> validate_required(~w(name)a)
    |> unique_constraint(:name, name: :divas_name_alias_index)
  end

  def item_changeset(%Antenna{toons: _toons} = antenna, item \\ :invalid) do
    adding =
      Enum.reduce item["videos"], [], fn tpl, result ->
        r =
          Enum.flat_map elem(tpl, 1), fn vid ->
            vid["divas"] || []
          end

        result ++ r
      end

    exists =
      ConCache.get_or_store(:divas, "divaname:all", fn ->
        Enum.map Repo.all(__MODULE__), &(&1.name)
      end)
      |> Exantenna.Filter.right_names(item)
      |> Enum.filter(fn name -> ! (name in adding) end)

    divas =
      Exantenna.Ecto.Changeset.get_or_changeset(__MODULE__, adding) ++
      Exantenna.Ecto.Changeset.get_or_changeset(__MODULE__, exists)

    put_assoc(change(antenna), :divas, divas)
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
