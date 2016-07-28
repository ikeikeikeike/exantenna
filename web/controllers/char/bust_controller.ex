defmodule Exantenna.Char.BustController do
  use Exantenna.Web, :controller

  alias Exantenna.Char
  alias Exantenna.Ecto.Q.Profile

  def index(conn, _params) do
    busts = Profile.get :bust, Char.query
    render(conn, "index.html", busts: busts, nav: busts)
  end

  def around(conn, %{"range" => range} = _params) do
    numeric = List.first String.split(range, "-")

    busts = Profile.get :bust, Char.query, numeric
    render(conn, "index.html", busts: busts, nav: Profile.get(:bust, Char.query))
  end

end
