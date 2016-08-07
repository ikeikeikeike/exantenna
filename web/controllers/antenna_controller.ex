defmodule Exantenna.AntennaController do
  use Exantenna.Web, :controller

  alias Exantenna.Es
  alias Exantenna.Diva
  alias Exantenna.Antenna
  alias Exantenna.Ecto.Q
  import Ecto.Query

  def home(conn, params) do
    words = params["q"]

    antennas =
      Antenna.essearch(words, params)
      |> Es.Paginator.paginate(Antenna.query_all, params)

    summaries =
      Antenna.essearch(words, params)
      |> Es.Paginator.paginate(Antenna.query_all, params)

    divas =
      Diva.query  # TODO: query_all or query
      # |> where([q], q.appeared > 0)
      # |> order_by([q], [desc: q.appeared])
      |> limit(4)
      |> Repo.all

    #  diva: Q.fuzzy_find(Diva, words)
    render(conn, "home.html", antennas: antennas, summaries: summaries, divas: divas)
  end

end
