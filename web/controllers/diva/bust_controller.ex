defmodule Exantenna.Diva.BustController do
  use Exantenna.Web, :controller

  alias Exantenna.Diva
  alias Exantenna.Ecto.Q.Profile

  def index(conn, _params) do
    busts = Profile.with :bust, Diva.query
    render(conn, "index.html", busts: busts, nav: busts)
  end

  def around(conn, %{"range" => range} = _params) do
    numeric = List.first String.split(range, "-")

    busts = Profile.with :bust, Diva.query, numeric
    render(conn, "index.html", busts: busts, nav: Profile.with(:bust, Diva.query))
  end

end
