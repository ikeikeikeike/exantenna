defmodule Exantenna.VideoMetadata do
  use Exantenna.Web, :model

  schema "video_metadatas" do
    belongs_to :site, Exantenna.Site
    belongs_to :video, Exantenna.Video

    field :url, :string

    field :title, :string
    field :content, :string
    field :embed_code, :string

    field :duration, :integer

    has_one :thumb, {"video_metadatas_thumbs", Exantenna.Thumb}, foreign_key: :assoc_id

    timestamps
  end

  @required_fields ~w()
  @optional_fields ~w(title url content embed_code duration)

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

end
