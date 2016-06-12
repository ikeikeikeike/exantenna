defmodule Exantenna.Metadata do
  use Exantenna.Web, :model

  schema "metadatas" do
    field :url, :string
    field :title, :string
    field :content, :string
    field :seo_title, :string
    field :seo_content, :string
    field :creator, :string
    field :publisher, :string
    field :published_at, Timex.Ecto.DateTime

    timestamps
  end

  @required_fields ~w(url title content seo_title seo_content creator publisher)
  @optional_fields ~w()

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:url)
  end
end
