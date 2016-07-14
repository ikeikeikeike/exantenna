defmodule Exantenna.EntryController do
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

    render(conn, "index.html", antennas: antennas, diva: Q.fuzzy_find(Diva, words))
  end

end
