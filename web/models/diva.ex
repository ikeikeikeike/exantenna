defmodule Exantenna.Diva do
  use Exantenna.Web, :model

  schema "divas" do
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

    has_one :thumb, {"divas_thumbs", Exantenna.Thumb}, foreign_key: :assoc_id

    timestamps
  end

  @required_fields ~w(name)
  @optional_fields ~w(alias kana romaji gyou height width bust bracup waist hip blood birthday)

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end