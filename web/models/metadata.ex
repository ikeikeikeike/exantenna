defmodule Exantenna.Metadata do
  use Exantenna.Web, :model
  alias Exantenna.Antenna

  @json_fields ~w(url title content seo_title seo_content creator publisher published_at)
  @derive {Poison.Encoder, only: Enum.map(@json_fields, &(String.to_atom(&1)))}
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

  @required_fields ~w(url title content published_at)
  @optional_fields ~w(seo_title seo_content creator publisher)

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_required(~w(url title published_at)a)
    |> validate_format(:url, ~r/^https?:\/\//)
    |> unique_constraint(:url)
  end

  def item_changeset(%Antenna{metadata: metadata} = _antenna, item \\ :invalid) do
    params = %{
      url: item["url"],
      title: item["title"],
      content: item["explain"],
      seo_title: item["seo_title"],
      seo_content: item["seo_explain"],
      creator: "",  # extract_domain(item["url"])
      publisher: "PERVERTING",
      published_at: Ecto.DateTime.utc,
    }

    metadata
    |> changeset(params)
  end

end
