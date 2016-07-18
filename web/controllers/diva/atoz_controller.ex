defmodule Exantenna.Diva.AtozController do
  use Exantenna.Web, :controller

  alias Exantenna.Diva
  import Ecto.Query

  @kunrei_romaji ~w{
    a i u e o
    ka ki ku ke ko
    sa si su se so
    ta ti tu te to
    na ni nu ne no
    ha hi hu he ho
    ma mi mu me mo
    ya    yu    yo
    ra ri ru re ro
    wa
  }

  def index(conn, _params) do
    letters =
      @kunrei_romaji
      |> Enum.map(fn letter ->
        divas =
          Diva.query  # TODO: query_all or query
          |> where([q], q.gyou == ^letter)
          # |> where([q], q.appeared > 0)
          |> where([q], not is_nil(q.gyou))
          |> limit(8)
          |> Repo.all
        {letter, divas}
      end)

    render(conn, "index.html", letters: letters)
  end

end
