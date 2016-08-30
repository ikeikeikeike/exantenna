defmodule Exantenna.CharController do
  use Exantenna.Web, :controller

  alias Exantenna.Es
  alias Exantenna.Repo
  alias Exantenna.Char
  alias Exantenna.Antenna
  alias Exantenna.Ecto.Q.Profile

  def index(conn, params) do
    sub = conn.private[:subdomain]

    qs = Profile.query :score, Profile.args(sub, Char, Char.query_all(2))
    pager = Repo.paginate(qs, params)

    render(conn, "index.html", pager: pager)
  end

  def show(conn, %{"name" => name} = params) do
    char = Repo.get_by!(Char.query_all(2), name: name)

    antennas =
      Antenna.essearch(char.name, params)
      |> Es.Paginator.paginate(Antenna.query_all, params)

    render(conn, "show.html", char: char, antennas: antennas)
  end

  def suggest(conn, %{"search" => search}) do
    names = Es.Suggester.completion(Char, search)
    render(conn, "suggest.json", names: names)
  end

end
