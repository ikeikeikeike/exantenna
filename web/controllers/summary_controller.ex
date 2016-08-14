defmodule Exantenna.SummaryController do
  use Exantenna.Web, :controller

  alias Exantenna.Es
  alias Exantenna.Diva
  alias Exantenna.Antenna
  alias Exantenna.Ecto.Q

  def index(conn, params) do
    words = params["q"]
    options = Map.merge params, %{
      "filter" => %{
        is_summary: true
      }
    }

    antennas =
      Antenna.essearch(words, options)
      |> Es.Paginator.paginate(Antenna.query_all, options)

    #  diva: Q.fuzzy_find(Diva, words)
    render(conn, "index.html", antennas: antennas)
  end

end
