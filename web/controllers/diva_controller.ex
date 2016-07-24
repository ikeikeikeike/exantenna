defmodule Exantenna.DivaController do
  use Exantenna.Web, :controller

  alias Exantenna.Es
  alias Exantenna.Repo
  alias Exantenna.Diva
  alias Exantenna.Antenna
  import Ecto.Query

  def index(conn, params) do
    divas =
      Diva.query  # TODO: query_all or query
      # |> where([q], q.appeared > 0)
      # |> order_by([q], [desc: q.appeared])
      |> limit(100)
      |> Repo.all

    render(conn, "index.html", divas: divas)
  end

  def show(conn, %{"name" => name} = params) do
    diva = Repo.get_by!(Diva.query_all, name: name)

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
