defmodule Exantenna.Toon do
  use Exantenna.Web, :model
  import Exantenna.Filter, only: [right_name?: 2]
  alias Exantenna.Antenna

  schema "toons" do
    has_one :thumb, {"toons_thumbs", Exantenna.Thumb}, foreign_key: :assoc_id

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
    |> update_change(:kana, &String.replace(&1 || "", ~r/(-|_)/, ""))
    |> update_change(:romaji, &String.replace(String.downcase(&1 || ""), ~r/(-|_)/, ""))
    |> validate_required(~w(name)a)
    |> validate_format(:romaji, ~r/^[a-z]\w+$/)
    |> validate_format(:url, ~r/^https?:\/\//)
  end

  def item_changeset(%Antenna{toons: _toons} = antenna, item \\ :invalid) do
    filters = Application.get_env(:exantenna, :toon_filters)[:title]

    names =
      ConCache.get_or_store(:exantenna_cache, "toonnamealias:all", fn ->
        Enum.map Repo.all(__MODULE__), &([name: &1.name, alias: &1.alias])
      end)
      |> Enum.filter(fn toon ->
        [name: name, alias: aka] = toon

        # XXX: Consider detection from video info's map |> item["videos"]
        cond do
          ! (aka in filters) && right_name?(aka, item) -> true
          ! (name in filters) && right_name?(name, item) -> true
          true -> false
        end
      end)
      |> Enum.map(fn toon ->
        toon[:name]
      end)

    toons = get_or_changeset(names)

    put_assoc(change(antenna), :toons, toons)
  end

  def get_or_changeset(names) when is_list(names),
    do: Enum.map names, &get_or_changeset(&1)
  def get_or_changeset(name) do
    case Repo.get_by(__MODULE__, name: name) do
      nil ->
        changeset(%__MODULE__{}, %{name: name})
      model ->
        model
    end
  end

end