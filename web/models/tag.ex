defmodule Exantenna.Tag do
  use Exantenna.Web, :model

  alias Exantenna.Antenna

  schema "tags" do
    has_many :thumbs, {"tags_thumbs", Exantenna.Thumb}, foreign_key: :assoc_id, on_delete: :delete_all
    has_many :scores, {"tags_scores", Exantenna.Score}, foreign_key: :assoc_id, on_replace: :delete

    many_to_many :antennas, Exantenna.Antenna, join_through: "antennas_tags"
    many_to_many :chars, Exantenna.Char, join_through: "chars_tags"
    many_to_many :toons, Exantenna.Toon, join_through: "toons_tags"

    field :name, :string
    field :kana, :string
    field :romaji, :string
    field :orig, :string
    field :gyou, :string

    field :outline, :string

    timestamps
  end

  @required_fields ~w(name)
  @optional_fields ~w(kana romaji orig gyou outline)

  @relational_fields ~w(antennas scores thumbs chars toons scores)a

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
    |> Exantenna.Ecto.Changeset.rubytext_changeset
    |> validate_required(~w(name)a)
    |> unique_constraint(:name)
  end

  def item_changeset(%Antenna{tags: _tags} = antenna, item \\ :invalid) do
    tags =
      Enum.reduce item["videos"], [], fn tpl, result ->
        r =
          Enum.flat_map elem(tpl, 1), fn vid ->
            (vid["tags"] || []) ++ (vid["divas"] || [])
          end

        result ++ r
      end

    adding =
      tags ++ item["tags"]
      |> Enum.reduce([], fn name, acc ->
        acc ++ String.split(name, [" ", "　", "・"])
      end)
      |> Enum.uniq

    tags =
      Exantenna.Ecto.Changeset.get_or_changeset(__MODULE__, adding)

    put_assoc(change(antenna), :tags, tags)
  end

  def aggs_changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> cast_assoc(:scores, required: true)
  end

  use Exantenna.Es

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
      orig: model.orig,
      romaji: model.romaji,
    ]
  end

  def esreindex, do: Es.Index.reindex __MODULE__, Repo.all(__MODULE__)

  def create_esindex(name \\ nil) do
    index = [type: estype, index: esindex(name)]
    Es.Schema.completion(index)
  end

end
