defmodule Exantenna.Video do
  use Exantenna.Web, :model

  alias Exantenna.Antenna
  alias Exantenna.VideoMetadata

  schema "videos" do
    has_one :antenna, Antenna
    has_many :metadatas, VideoMetadata

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
      Enum.reduce item["videos"], [], fn tpl, result ->
        require IEx; IEx.pry
        r =
          Enum.map elem(tpl, 1), fn vid ->
            %{
              content: vid["content"],
              title: vid["title"],
              url: vid["url"],
              embed_code: vid["embed_code"],
              duration: vid["duration"],
              thumbs: Enum.map(vid["image_urls"], &(%{"src" => &1})),

              # TODO: site inserting
            }
          end

        result ++ r
      end

    video
    |> changeset(%{metadatas: metadatas})
    |> cast_assoc(:metadatas, required: true)
  end

end
