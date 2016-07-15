defmodule Exantenna.EntryController do
  use Exantenna.Web, :controller

  alias Exantenna.Es
  alias Exantenna.Diva
  alias Exantenna.Antenna
  alias Exantenna.Ecto.Q

  def home(conn, params) do
    words = params["search"]

    antennas =
      Antenna.essearch(words, params)
      |> Es.Paginator.paginate(Antenna.query_all, params)

    render(conn, "home.html", antennas: antennas, diva: Q.fuzzy_find(Diva, words))
  end

  def show(conn, %{"id" => id, "title" => title}) do
    render(conn, "show.html", antenna: Repo.get!(Antenna.query_all, id), antennas: [])
  end

  def show(conn, %{"id" => id} = params) do
    render(conn, "show.html", antenna: Repo.get!(Antenna.query_all, id), antennas: [])
  end



end
