defmodule Exantenna.DivaController do
  use Exantenna.Web, :controller

  alias Exantenna.Repo
  alias Exantenna.Diva
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

end
