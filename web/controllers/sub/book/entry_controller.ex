defmodule Exantenna.Sub.Book.EntryController do
  use Exantenna.Web, :controller

  alias Exantenna.Sub.Book

  alias Exantenna.Es
  alias Exantenna.Diva
  alias Exantenna.Antenna
  alias Exantenna.Ecto.Q

  plug :put_layout, {Book.LayoutView, "app.html"}

  def index(conn, params) do
    words = params["q"]

    antennas =
      Antenna.essearch(words, params)
      |> Es.Paginator.paginate(Antenna.query_all, params)

    #  diva: Q.fuzzy_find(Diva, words)
    render(conn, Exantenna.EntryView, "index.html", antennas: antennas)
  end

  def show(conn, %{"id" => _id, "title" => _title} = params) do
    show conn, params
  end

  def show(conn, %{"id" => id} = params) do
    antenna = Repo.get!(Antenna.query_all, id)

    antennas =
      Antenna.essearch(antenna.metadata.title, params)
      |> Es.Paginator.paginate(Antenna.query_all, params)

    render(conn, Book.EntryView, "show.html", antenna: antenna, antennas: antennas, summaries: antennas)
  end

  def view(conn, %{"id" => _id, "title" => _title} = params) do
    view conn, params
  end

  def view(conn, %{"id" => id} = params) do
    antenna = Repo.get!(Antenna.query_all, id)

    # antennas =
      # Antenna.essearch(antenna.metadata.title, params)
      # |> Es.Paginator.paginate(Antenna.query_all, params)

    conn
    |> put_layout({Book.LayoutView, "view.html"})
    |> render(Book.EntryView, "view.html", antenna: antenna, antennas: [])
  end

end
