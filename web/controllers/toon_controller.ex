defmodule Exantenna.ToonController do
  use Exantenna.Web, :controller

  alias Exantenna.Es
  alias Exantenna.Repo
  alias Exantenna.Toon
  alias Exantenna.Antenna
  alias Exantenna.Ecto.Q.Profile

  def index(conn, params) do
    sub = conn.private[:subdomain]

    qs = Profile.query :score, Profile.args(sub, Toon, Toon.query_all(2))
    pager = Repo.paginate(qs, params)

    render(conn, "index.html", pager: pager)
  end

  def show(conn, %{"name" => name} = params) do
    toon = Repo.get_by!(Toon.query_all(2), name: name)

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
