defmodule Exantenna.DivaController do
  use Exantenna.Web, :controller

  alias Exantenna.Es
  alias Exantenna.Repo
  alias Exantenna.Diva
  alias Exantenna.Antenna
  import Ecto.Query

  def index(conn, params) do
    pager =
      Diva.query_all(2)
      # |> where([q], q.appeared > 0)
      # |> order_by([q], [desc: q.appeared])
      |> Repo.paginate(params)

    render(conn, "index.html", pager: pager)
  end

  def show(conn, %{"name" => name} = params) do
    diva = Repo.get_by!(Diva.query_all(2), name: name)

    antennas =
      Antenna.essearch(diva.name, params)
      |> Es.Paginator.paginate(Antenna.query_all, params)

    render(conn, "show.html", diva: diva, antennas: antennas)
  end

  def suggest(conn, %{"search" => search}) do
    names = Es.Suggester.completion(Diva, search)
    render(conn, "suggest.json", names: names)
  end

end
