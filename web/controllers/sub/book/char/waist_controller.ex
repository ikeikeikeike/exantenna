defmodule Exantenna.Char.WaistController do
  use Exantenna.Web, :controller

  alias Exantenna.Char
  alias Exantenna.Ecto.Q.Profile

  def index(conn, _params) do
    waists = Profile.get :waist, Char.query
    render(conn, "index.html", waists: waists, nav: waists)
  end

  def sub(conn, %{"name" => name} = _params) do
    numeric = List.first String.split(name, "-")

    waists = Profile.get :waist, Char.query, numeric
    render(conn, "index.html", waists: waists, nav: Profile.get(:waist, Char.query))
  end


end
