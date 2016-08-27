defmodule Exantenna.Sub.Video.EntryController do
  use Exantenna.Web, :controller

  alias Exantenna.Sub.Video

  alias Exantenna.Es
  alias Exantenna.Diva
  alias Exantenna.Antenna
  alias Exantenna.Ecto.Q

  plug :put_layout, {Video.LayoutView, "app.html"}
  plug DomainPlug.Esparams

  def index(conn, params) do
    conn
    |> put_view(Exantenna.EntryView)
    |> Exantenna.EntryController.index(params)
  end

  def show(conn, %{"id" => id} = params) do
    conn
    |> put_view(Video.EntryView)
    |> Exantenna.EntryController.show(params)
  end

  def show(conn, %{"id" => _id, "title" => _title} = params) do
    show conn, params
  end

end
