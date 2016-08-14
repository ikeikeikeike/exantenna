defmodule Exantenna.Sub.Book.EntryController do
  use Exantenna.Web, :controller

  alias Exantenna.Sub.Book

  alias Exantenna.Es
  alias Exantenna.Diva
  alias Exantenna.Antenna
  alias Exantenna.Ecto.Q

  plug :put_layout, {Book.LayoutView, "app.html"}
  plug DomainPlug.Esparams

  def index(conn, params) do
    conn
    |> put_view(Exantenna.EntryView)
    |> Exantenna.EntryController.index(params)
  end

  def show(conn, %{"id" => _id, "title" => _title} = params) do
    show conn, params
  end

  def show(conn, %{"id" => id} = params) do
    conn
    |> put_view(Book.EntryView)
    |> Exantenna.EntryController.show(params)
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
