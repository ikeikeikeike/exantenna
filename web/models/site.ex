defmodule Exantenna.Site do
  use Exantenna.Web, :model

  schema "sites" do
    field :name, :string

    field :url, :string
    field :domain, :string

    field :rss, :string

    has_one :video_metadata, Exantenna.VideoMetadata
    has_one :thumb, {"sites_thumbs", Exantenna.Thumb}, foreign_key: :assoc_id

    timestamps
  end

  @required_fields ~w(domain)
  @optional_fields ~w(name rss url)

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
