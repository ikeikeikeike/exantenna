defmodule Exantenna.Diva.BustController do
  use Exantenna.Web, :controller

  alias Exantenna.Diva
  alias Exantenna.Ecto.Q.Profile

  def index(conn, _params) do
    busts = Profile.get :bust, Diva, Diva.query
    render(conn, "index.html", busts: busts, nav: busts)
  end

  def sub(conn, %{"name" => name} = _params) do
    numeric = List.first String.split(name, "-")

    busts = Profile.get :bust, Diva, Diva.query, numeric
    render(conn, "index.html", busts: busts, nav: Profile.get(:bust, Diva, Diva.query))
  end

end
