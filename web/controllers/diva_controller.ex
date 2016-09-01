defmodule Exantenna.DivaController do
  use Exantenna.Web, :controller

  alias Exantenna.Es
  alias Exantenna.Repo
  alias Exantenna.Diva
  alias Exantenna.Antenna
  alias Exantenna.Ecto.Q.Profile

  def index(conn, params) do
    sub = conn.private[:subdomain]

    qs = Profile.query :score, Profile.args(sub, Diva, Diva.query_all(1))
    pager = Repo.paginate(qs, params)

    render(conn, "index.html", pager: pager)
  end

  def show(conn, %{"name" => name} = params) do
    diva = Repo.get_by!(Diva.query_all(1), name: name)

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
