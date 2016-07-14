defmodule Exantenna.EntryController do
  use Exantenna.Web, :controller

  alias Exantenna.Es
  alias Exantenna.Diva
  alias Exantenna.Antenna
  alias Exantenna.Ecto.Q

  def index(conn, params) do
    words = params["search"]

    entries =
      Antenna.essearch(words, params)
      |> Es.Paginator.paginate(params)

    render(conn, "index.html", entries: entries, diva: Q.fuzzy_find(Diva, words))
  end

end
