defmodule Exantenna.Tag do
  use Exantenna.Web, :model

  alias Exantenna.Antenna

  schema "tags" do
    has_many :thumbs, {"tags_thumbs", Exantenna.Thumb}, foreign_key: :assoc_id, on_delete: :delete_all
    has_many :scores, {"tags_scores", Exantenna.Score}, foreign_key: :assoc_id

    many_to_many :antennas, Exantenna.Antenna, join_through: "antennas_tags"
    many_to_many :chars, Exantenna.Antenna, join_through: "chars_tags"
    many_to_many :toons, Exantenna.Antenna, join_through: "toons_tags"

    field :name, :string
    field :kana, :string
    field :romaji, :string
    field :orig, :string
    field :gyou, :string

    timestamps
  end

  @required_fields ~w(name)
  @optional_fields ~w(kana romaji orig gyou)

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
      |> Enum.uniq

    tags =
      Exantenna.Ecto.Changeset.get_or_changeset(__MODULE__, adding)

    put_assoc(change(antenna), :tags, tags)
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
