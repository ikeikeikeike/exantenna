defmodule Exantenna.Video do
  use Exantenna.Web, :model

  alias Exantenna.Antenna
  alias Exantenna.VideoMetadata

  schema "videos" do
    has_one :antenna, Exantenna.Antenna

    # has_many :thumbs, {"videos_thumbs", Exantenna.Thumb}, foreign_key: :assoc_id
    has_many :metadatas, Exantenna.VideoMetadata

    timestamps
  end

  @required_fields ~w()
  @optional_fields ~w()

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def item_changeset(%Antenna{video: video} = _antenna, item \\ :invalid) do
    metadatas =
      Enum.map item[:videos], fn viditem ->
        VideoMetadata.item_changeset %VideoMetadata{}, viditem
      end

    video
    |> changeset(%{metadatas: metadatas})
    |> cast_assoc(:metadatas, required: true)
  end

end
