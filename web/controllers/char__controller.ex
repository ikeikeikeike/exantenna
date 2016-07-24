defmodule Exantenna.CharController do
  use Exantenna.Web, :controller

  alias Exantenna.Es
  alias Exantenna.Repo
  alias Exantenna.Char
  alias Exantenna.Antenna
  import Ecto.Query

  def index(conn, params) do
    chars =
      Char.query  # TODO: query_all or query
      # |> where([q], q.appeared > 0)
      # |> order_by([q], [desc: q.appeared])
      |> limit(100)
      |> Repo.all

    render(conn, "index.html", chars: chars)
  end

  def show(conn, %{"name" => name} = params) do
    char = Repo.get_by!(Char.query_all, name: name)

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
