defmodule Exantenna.Diva do
  use Exantenna.Web, :model

  alias Exantenna.Thumb
  alias Exantenna.Antenna

  schema "divas" do
    has_one :thumb, {"divas_thumbs", Thumb}, foreign_key: :assoc_id
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

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> update_change(:kana,   &String.replace(&1 || "", ~r/(-|_)/, ""))
    |> update_change(:romaji, &String.replace(String.downcase(&1 || ""), ~r/(-|_)/, ""))
    |> update_change(:blood,  &String.replace(String.upcase(&1 || ""), ~r/[^A|B|AB|O|RH|\+|\-]/i, ""))
    |> update_change(:bracup, &String.replace(String.upcase(&1 || ""), ~r/(カップ|CUP| |\(|\))/iu, ""))
    |> validate_required(~w(name)a)
    |> validate_format(:romaji, ~r/^[a-z]\w+$/)  # TODO: Make sure that constains blank value
  end

  def item_changeset(%Antenna{toons: _toons} = antenna, item \\ :invalid) do
    filters =
      Enum.reduce item["videos"], [], fn tpl, result ->
        r =
          Enum.flat_map elem(tpl, 1), fn vid ->
            vid["divas"] || []
          end

        result ++ r
      end

    names =
      ConCache.get_or_store(:exantenna_cache, "divaname:all", fn ->
        Enum.map Repo.all(__MODULE__), &(&1.name)
      end)
      |> Exantenna.Filter.right_names(item)
      |> Enum.filter(fn name ->
        ! (name in filters)
      end)

    divas = get_or_changeset(filters) ++ get_or_changeset(names)

    put_assoc(change(antenna), :divas, divas)
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
