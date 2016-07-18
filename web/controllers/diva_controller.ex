defmodule Exantenna.DivaController do
  use Exantenna.Web, :controller

  alias Exantenna.Diva

  def index(conn, params) do
    words = params["search"]

    divas =
      Diva.essearch(words, params)
      |> Es.Paginator.paginate(Diva.query_all, params)

    render(conn, "index.html", diavs: diavs)
  end

end
