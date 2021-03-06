defmodule Exantenna.AntennaController do
  use Exantenna.Web, :controller

  alias Exantenna.Es
  alias Exantenna.Diva
  alias Exantenna.Toon
  alias Exantenna.Antenna
  alias Exantenna.Ecto.Q
  import Ecto.Query

  def index(conn, params) do
    sub = conn.private[:subdomain]
    words = params["q"]

    antennas =
      Antenna.essearch(words, params)
      |> Es.Paginator.paginate(Antenna.query_all, params)

    options = %{
      "sort" => :random,
      "filter" => Map.merge(Map.get(params, "filter", %{}), %{
        is_summary: true
      })
    }
    summaries =
      Antenna.essearch(words, options)
      |> Es.Paginator.paginate(Antenna.query_all, options)

    divas =
      Q.Profile.query(:score, Q.Profile.args(sub, Diva, Diva.query_all(2)))
      |> limit(4)
      |> Repo.all

    toons =
      Q.Profile.query(:score, Q.Profile.args(sub, Toon, Toon.query_all(2)))
      |> limit(4)
      |> Repo.all

    #  diva: Q.fuzzy_find(Diva, words)
    render(conn, "index.html",
      antennas: antennas, summaries: summaries,
      divas: divas, toons: toons
    )
  end

end
