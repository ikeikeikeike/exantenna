defmodule Exantenna.Diva.BracupController do
  use Exantenna.Web, :controller

  alias Exantenna.Diva
  import Ecto.Query

  def index(conn, _params) do
    bracups =
      Enum.map(?A..?Z, &IO.iodata_to_binary([&1]))
      |> Enum.map(fn bracup ->
        divas =
          Diva.query
          |> where([q], q.bracup == ^bracup)
          # |> where([q], q.appeared > 0)
          |> where([q], not is_nil(q.bracup))
          |> order_by([q], [asc: q.bust])
          |> Repo.all
        {bracup, divas}
      end)

    render(conn, "index.html", bracups: bracups)
  end

end
