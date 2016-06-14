defmodule Exantenna.VideoMetadata do
  use Exantenna.Web, :model

  schema "video_metadatas" do
    belongs_to :video, Exantenna.Video

    field :url, :string

    field :title, :string
    field :content, :string
    field :embed_code, :string

    field :duration, :integer

    has_one :site, {"video_metadatas_sites", Exantenna.Site}, foreign_key: :assoc_id

    timestamps
  end

  @required_fields ~w(url title)
  @optional_fields ~w(content embed_code duration)

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
