defmodule Exantenna.Character do
  use Exantenna.Web, :model
  alias Exantenna.Antenna

  schema "characters" do
    belongs_to :anime, Exantenna.Anime
    has_one :thumb, {"characters_thumbs", Exantenna.Thumb}, foreign_key: :assoc_id

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
  @optional_fields ~w(alias kana romaji gyou height weight bust bracup waist hip blood birthday)

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
