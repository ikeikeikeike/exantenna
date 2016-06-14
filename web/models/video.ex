defmodule Exantenna.Video do
  use Exantenna.Web, :model

  schema "videos" do
    has_one :antenna, Exantenna.Antenna

    # has_many :thumbs, {"videos_thumbs", Exantenna.Thumb}, foreign_key: :assoc_id
    has_many :metadatas, Exantenna.VideoMetadata

    timestamps
  end

  @required_fields ~w(url title)
  @optional_fields ~w(content embed_code duration)

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
