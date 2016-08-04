defmodule Exantenna.SummaryController do
  use Exantenna.Web, :controller

  alias Exantenna.Es
  alias Exantenna.Diva
  alias Exantenna.Antenna
  alias Exantenna.Ecto.Q

  def index(conn, params) do
    words = params["search"]

    antennas =
      Antenna.essearch(words, params)
      |> Es.Paginator.paginate(Antenna.query_all, params)

    #  diva: Q.fuzzy_find(Diva, words)
    render(conn, "index.html", antennas: antennas)
  end

end
