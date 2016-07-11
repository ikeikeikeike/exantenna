defmodule Exantenna.Tag do
  use Exantenna.Web, :model
  alias Exantenna.Antenna

  schema "tags" do
    has_many :thumbs, {"tags_thumbs", Exantenna.Thumb}, foreign_key: :assoc_id, on_delete: :delete_all
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
    |> update_change(:kana, &String.replace(&1 || "", ~r/(-|_)/, ""))
    |> update_change(:romaji, &String.replace(String.downcase(&1 || ""), ~r/(-|_)/, ""))
    |> validate_required(~w(name)a)
    |> validate_format(:romaji, ~r/^[a-z]\w+$/)
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

    tags =
      tags ++ item["tags"]
      |> Enum.uniq
      |> Enum.map(fn name ->
        case Repo.get_by(__MODULE__, name: name) do
          nil -> changeset(%__MODULE__{}, %{name: name})
          tag -> tag
        end
      end)

    put_assoc(change(antenna), :tags, tags)
  end

end
