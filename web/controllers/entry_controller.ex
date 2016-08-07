defmodule Exantenna.EntryController do
  use Exantenna.Web, :controller

  alias Exantenna.Es
  alias Exantenna.Diva
  alias Exantenna.Antenna
  alias Exantenna.Ecto.Q

  def index(conn, params) do
    words = params["q"]

    antennas =
      Antenna.essearch(words, params)
      |> Es.Paginator.paginate(Antenna.query_all, params)

    #  diva: Q.fuzzy_find(Diva, words)
    render(conn, "index.html", antennas: antennas)
  end

  def show(conn, %{"id" => _id, "title" => _title} = params) do
    show conn, params
  end

  def show(conn, %{"id" => id} = params) do
    antenna = Repo.get!(Antenna.query_all, id)

    antennas =
      Antenna.essearch(antenna.metadata.title, params)
      |> Es.Paginator.paginate(Antenna.query_all, params)

    render(conn, "show.html", antenna: antenna, antennas: antennas)
  end

end
