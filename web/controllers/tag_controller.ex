defmodule Exantenna.TagController do
  use Exantenna.Web, :controller

  alias Exantenna.Es
  alias Exantenna.Repo

  alias Exantenna.Tag
  alias Exantenna.Antenna
  import Ecto.Query

  # TODO: below

  def index(conn, params) do
    pager =
      Tag.query_all(2)
      # |> where([q], q.appeared > 0)
      # |> order_by([q], [desc: q.appeared])
      |> Repo.paginate(params)
      |> Es.Paginator.addition

    render(conn, "index.html", pager: pager)
  end

  def show(conn, %{"name" => name} = params) do
    tag = Repo.get_by!(Tag.query_all(2), name: name)

    antennas =
      Antenna.essearch(tag.name, params)
      |> Es.Paginator.paginate(Antenna.query_all, params)

    render(conn, "show.html", tag: tag, antennas: antennas)
  end

  def suggest(conn, %{"search" => search}) do
    names = Es.Suggester.completion(Tag, search)
    render(conn, "suggest.json", names: names)
  end

end
