defmodule Exantenna.TagController do
  use Exantenna.Web, :controller

  alias Exantenna.Es
  alias Exantenna.Repo
  alias Exantenna.Tag
  alias Exantenna.Antenna
  import Ecto.Query

  def index(conn, params) do
    tags =
      Tag.query  # TODO: query_all or query
      # |> where([q], q.appeared > 0)
      # |> order_by([q], [desc: q.appeared])
      |> limit(100)
      |> Repo.all

    render(conn, "index.html", tags: tags)
  end

  def show(conn, %{"name" => name} = params) do
    tag = Repo.get_by!(Tag.query_all, name: name)

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
