defmodule Exantenna.Char do
  use Exantenna.Web, :model

  schema "chars" do
    has_one :thumb, {"chars_thumbs", Exantenna.Thumb}, foreign_key: :assoc_id

    many_to_many :tags, Exantenna.Tag, join_through: "chars_tags"
    many_to_many :toons, Exantenna.Toon, join_through: "toons_chars"

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
    |> update_change(:kana, &String.replace(&1 || "", ~r/(-|_)/, ""))
    |> update_change(:romaji, &String.replace(String.downcase(&1 || ""), ~r/(-|_)/, ""))
    |> update_change(:blood,  &String.replace(String.upcase(&1 || ""), ~r/[^A|B|AB|O|RH|\+|\-]/i, ""))
    |> update_change(:bracup, &String.replace(String.upcase(&1 || ""), ~r/(カップ|CUP| |\(|\))/iu, ""))
    |> validate_required(~w(name)a)
    |> validate_format(:romaji, ~r/^[a-z]\w+$/)
    |> unique_constraint(:name, name: :chars_name_alias_index)
  end
end
