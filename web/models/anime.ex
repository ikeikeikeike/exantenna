defmodule Exantenna.Anime do
  use Exantenna.Web, :model

  schema "animes" do
    field :name, :string
    field :alias, :string
    field :kana, :string
    field :romaji, :string
    field :gyou, :string
    field :url, :string
    field :author, :string
    field :works, :string
    field :release_date, Ecto.DateTime
    field :outline, :string

    timestamps
  end

  @required_fields ~w(name alias kana romaji gyou url author works release_date outline)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
