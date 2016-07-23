defmodule Exantenna.Diva.BustController do
  use Exantenna.Web, :controller

  alias Exantenna.Diva
  import Ecto.Query

  def index(conn, _params) do
    busts =
      [60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 125, 130, 135]
      |> Enum.map(fn bust ->
        divas =
          Diva.query
          |> where([q], q.bust >= ^bust)
          |> where([q], q.bust < ^(bust + 5))
          |> where([q], q.bust > 60)
          # |> where([q], q.appeared > 0)
          |> where([q], not is_nil(q.bust))
          |> order_by([q], [asc: q.bust])
          |> Repo.all
        {bust, divas}
      end)

    render(conn, "index.html", busts: busts)
  end

end
