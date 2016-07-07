defmodule Exantenna.Metadata do
  use Exantenna.Web, :model
  alias Exantenna.Antenna

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

  @required_fields ~w(url title content creator publisher)
  @optional_fields ~w(seo_title seo_content)

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:url)
  end

  def item_changeset(%Antenna{metadata: metadata} = _antenna, item \\ :invalid) do
    params = %{
      url: item["url"],
      title: item["title"],
      content: item["explain"],
      seo_title: item["seo_explain"],
      seo_content: item["seo_content"],
      creator: "",  # extract_domain(item["url"])
      publisher: "PERVERTING",
      published_at: Ecto.DateTime.utc,
    }

    metadata
    |> changeset(params)
  end

end
