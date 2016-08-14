defmodule Exantenna.Api.V1.PartsController do
  use Exantenna.Web, :controller

  alias Exantenna.Es
  alias Exantenna.Repo
  alias Exantenna.Char
  alias Exantenna.Antenna

  import Exantenna.Imitation.Converter, only: [to_i: 1]

  def json(conn, params) do
    # type =
      # case params["adsense_type"] do
        # "3d" -> %{is_3d: true}
        # "2d" -> %{is_2d: true}
        # _    -> %{}
      # end
    filter =
      case params["media_type"] do
        "movie" -> %{is_video: true}
        "image" -> %{is_book: true}
        _       -> %{}
        # "movie" -> %{is_summary: true, is_video: true}
        # "image" -> %{is_summary: true, is_book: true}
        # _       -> %{is_summary: true}
      end

    per_page = (params["per_item"] || 5) |> to_i
	if per_page > 50 do
		per_page = 50
    end

    options = %{
      filter: filter,
      per_page: per_page,
    }

    words = params["q"]

    antennas =
      Antenna.essearch(words, options)
      |> Es.Paginator.paginate(Antenna.query_all, options)

    conn
    |> render("parts.json", antennas: antennas.entries)
  end

end
