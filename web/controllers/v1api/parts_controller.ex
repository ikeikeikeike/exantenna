defmodule Exantenna.V1Api.PartsController do
  use Exantenna.Web, :controller

  alias Exantenna.Es
  alias Exantenna.Repo
  alias Exantenna.Char
  alias Exantenna.Antenna

  def json(conn, params) do
    words = params["search"]

    antennas =
      Antenna.essearch(words, params)
      |> Es.Paginator.paginate(Antenna.query_all, params)

    render(conn, "parts.json", antennas: antennas.entries)
  end

end
