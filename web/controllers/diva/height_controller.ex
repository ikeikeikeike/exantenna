defmodule Exantenna.Diva.HeightController do
  use Exantenna.Web, :controller

  alias Exantenna.Diva, as: Model
  import Ecto.Query

  def index(conn, _params) do
    heights =
      [130, 135, 140, 145, 150, 155, 160, 165, 170, 175, 180, 185, 190]
      |> Enum.map(fn height ->
        divas =
          Model
          |> where([q], q.height >= ^height)
          |> where([q], q.height < ^(height + 5))
          |> where([q], q.height > 130)
          # |> where([q], q.appeared > 0)
          |> where([q], not is_nil(q.height))
          |> order_by([q], [asc: q.height])
          |> Exantenna.Repo.all
        {height, divas}
      end)

    render(conn, "index.html", heights: heights)
  end

end
