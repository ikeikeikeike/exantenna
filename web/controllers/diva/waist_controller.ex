defmodule Exantenna.Diva.WaistController do
  use Exantenna.Web, :controller

  alias Exantenna.Diva
  import Ecto.Query

  def index(conn, _params) do
    waists =
      [40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100]
      |> Enum.map(fn waist ->
        divas =
          Diva.query
          |> where([q], q.waist >= ^waist)
          |> where([q], q.waist < ^(waist + 5))
          |> where([q], q.waist > 40)
          # |> where([q], q.appeared > 0)
          |> where([q], not is_nil(q.waist))
          |> order_by([q], [asc: q.waist])
          |> Repo.all
        {waist, divas}
      end)

    render(conn, "index.html", waists: waists)
  end

end
