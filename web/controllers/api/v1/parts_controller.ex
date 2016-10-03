defmodule Exantenna.Api.V1.PartsController do
  use Exantenna.Web, :controller

  alias Exantenna.Es
  alias Exantenna.Repo
  alias Exantenna.Char
  alias Exantenna.Antenna
  alias Exantenna.Ecto.Extractor

  import Exantenna.Imitation.Converter, only: [to_i: 1]

  def json(conn, params) do
    # type =
      # case params["adsense_type"] do
        # "3d" -> %{is_3d: true}
        # "2d" -> %{is_2d: true}
        # _    -> %{}
      # end
    # TODO: below
    filter =
      case params["media_type"] do
        # "movie" -> %{is_video: true}
        # "image" -> %{is_book: true}
        # _       -> %{}
        "movie" -> %{is_summary: true, is_video: true}
        "image" -> %{is_summary: true, is_book: true}
        _       -> %{is_summary: true}
      end

    per_page = (params["per_item"] || 10) |> to_i
	if per_page > 50 do
		per_page = 50
    end

    options = %{
      sort: :random,
      filter: filter,
      per_page: per_page,
    }

    words = params["q"]

    entries =
      ConCache.get_or_store :apiv1, "parts:#{words}:#{inspect options}", fn ->
        antennas =
          Antenna.essearch(words, options)
          |> Es.Paginator.paginate(Antenna.query_all, options)

        Enum.filter antennas.entries, fn an ->
          !(an.id in [135]) && length(Extractor.thumb(an)) > 0
        end
      end

    conn
    |> render("parts.json", antennas: entries)
  end

end
