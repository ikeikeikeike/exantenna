defmodule Exantenna.Video do
  use Exantenna.Web, :model

  alias Exantenna.Antenna
  alias Exantenna.VideoMetadata
  alias Exantenna.Redis.Imginfo

  schema "videos" do
    has_one :antenna, Antenna
    has_many :metadatas, VideoMetadata

    timestamps
  end

  @required_fields ~w()
  @optional_fields ~w()

  def full_relational_fields, do: @full_relational_fields
  @full_relational_fields [
    antenna: Antenna.full_relational_fields,
    metadatas: [:thumbs, :site]
  ]

  @relational_fields [
    :antenna,
    metadatas: [:thumbs, :site]
  ]

  def query do
    from e in __MODULE__,
    preload: ^@relational_fields
  end

  def query_all do
    from e in __MODULE__,
    preload: ^@full_relational_fields
  end

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def item_changeset(%Antenna{video: video} = _antenna, item \\ :invalid) do
    metadatas =
      Enum.reduce item["videos"], [], fn tpl, result ->
        r =
          Enum.map elem(tpl, 1), fn vid ->
            %{
              content: vid["content"],
              title: vid["title"],
              url: vid["url"],
              embed_code: vid["embed_code"],
              duration: vid["duration"],
              thumbs: Enum.map(vid["image_urls"] || [], fn src ->
                case Imginfo.get(src) do
                  nil -> %{"src" => src}
                  inf -> inf
                end
              end),

              # TODO: site inserting
            }
          end

        result ++ r
      end

    video
    |> changeset(%{metadatas: metadatas})
    |> cast_assoc(:metadatas, required: false)
  end

end
