defmodule Exantenna.Diva do
  use Exantenna.Web, :model
  alias Exantenna.Antenna

  schema "divas" do
    has_one :thumb, {"divas_thumbs", Exantenna.Thumb}, foreign_key: :assoc_id
    many_to_many :antennas, Exantenna.Antenna, join_through: "antennas_divas"

    field :name, :string
    field :alias, :string
    field :kana, :string
    field :romaji, :string
    field :gyou, :string

    field :height, :integer
    field :width, :integer

    field :bust, :integer
    field :bracup, :string
    field :waist, :integer
    field :hip, :integer

    field :blood, :string
    field :birthday, Ecto.Date

    timestamps
  end

  @required_fields ~w(name)
  @optional_fields ~w(alias kana romaji gyou height width bust bracup waist hip blood birthday)

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def item_changeset(%Antenna{animes: _animes} = antenna, item \\ :invalid) do
    names =
      Enum.reduce item["videos"], [], fn tpl, result ->
        r =
          Enum.flat_map elem(tpl, 1), fn vid ->
            vid["divas"]
          end

        result ++ r
      end

    divas =
      Enum.map names, fn name ->
        query = from v in __MODULE__, where: v.name == ^name
        case Repo.one(query) do
          nil ->
            changeset(%__MODULE__{}, %{name: name})
          diva ->
            diva
        end
      end

    names =
      ConCache.get_or_store(:exantenna_cache, "divaname:all", fn ->
        Repo.all __MODULE__, &(&1.name)
      end)
      |> Enum.filter(fn name ->
        bool = Exantenna.Filter.right_name?(name)
        bool = bool && !(name in names)

        cond do
          bool && String.contains?(item["title"])   -> true
          bool && String.contains?(item["explain"]) -> true
          bool && name in item["tags"]              -> true
          true                                      -> false
        end
      end)

    divas =
      divas ++
      Enum.map names, fn name ->
        case Repo.get_by(__MODULE__, name: name) do
          nil ->
            changeset(%__MODULE__{}, %{name: name})
          diva ->
            diva
        end
      end

    put_assoc(change(antenna), :divas, divas)
  end

end
