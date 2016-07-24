defmodule Exantenna.ToonController do
  use Exantenna.Web, :controller

  alias Exantenna.Es
  alias Exantenna.Repo
  alias Exantenna.Toon
  alias Exantenna.Antenna
  import Ecto.Query

  def index(conn, params) do
    toons =
      Toon.query  # TODO: query_all or query
      # |> where([q], q.appeared > 0)
      # |> order_by([q], [desc: q.appeared])
      |> limit(100)
      |> Repo.all

    render(conn, "index.html", toons: toons)
  end

  def show(conn, %{"name" => name} = params) do
    toon = Repo.get_by!(Toon.query_all, name: name)

    antennas =
      Antenna.essearch(toon.name, params)
      |> Es.Paginator.paginate(Antenna.query_all, params)

    render(conn, "show.html", toon: toon, antennas: antennas)
  end

  def suggest(conn, %{"search" => search}) do
    names = Es.Suggester.completion(Toon, search)
    render(conn, "suggest.json", names: names)
  end

end
