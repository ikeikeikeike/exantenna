defmodule Exantenna.Diva.HipController do
  use Exantenna.Web, :controller

  alias Exantenna.Diva, as: Model
  import Ecto.Query

  def index(conn, _params) do
    hips =
      [50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120]
      |> Enum.map(fn hip ->
        divas =
          Model
          |> where([q], q.hip >= ^hip)
          |> where([q], q.hip < ^(hip + 5))
          |> where([q], q.hip > 50)
          # |> where([q], q.appeared > 0)
          |> where([q], not is_nil(q.hip))
          |> order_by([q], [asc: q.hip])
          |> Exantenna.Repo.all
        {hip, divas}
      end)

    render(conn, "index.html", hips: hips)
  end

end
