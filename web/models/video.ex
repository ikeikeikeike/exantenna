defmodule Exantenna.Video do
  use Exantenna.Web, :model

  alias Exantenna.Site
  alias Exantenna.Antenna
  alias Exantenna.VideoMetadata
  alias Exantenna.Redis.Imginfo

  import Exantenna.Blank
  import Exantenna.Ecto.Changeset, only: [get_or_changeset: 2]

  @json_fields ~w(metadatas)
  @derive {Poison.Encoder, only: Enum.map(@json_fields, &(String.to_atom(&1)))}
  schema "videos" do
    has_one :antenna, Antenna
    has_many :metadatas, VideoMetadata

    field :elements, :integer

    timestamps
  end

  @required_fields ~w()
  @optional_fields ~w(elements)

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
      Enum.reduce(item["videos"], [], fn tpl, result ->
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
              site: fn url ->
                u = URI.parse(url)
                url = URI.to_string(%URI{scheme: u.scheme, host: u.host})

                case get_or_changeset(Site, %{domain: u.host}) do
                  %Site{} = model ->
                    model
                  cset ->
                    %{
                      "name" => u.host,
                      "url" => url,
                      "domain" => u.host,
                    }
                end
              end.(vid["url"])
            }
          end

        result ++ r
      end)
      |> Enum.filter(fn meta ->
        ! blank?(meta[:embed_code]) || ! blank?(meta[:url])
      end)

    codes = Enum.filter metadatas, & !blank?(&1[:embed_code])

    video
    |> changeset(%{metadatas: metadatas, elements: length(codes)})
    |> cast_assoc(:metadatas, required: false)
  end

end
