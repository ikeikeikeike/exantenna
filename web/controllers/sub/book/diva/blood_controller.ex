defmodule Exantenna.Diva.BloodController do
  use Exantenna.Web, :controller

  alias Exantenna.Diva
  alias Exantenna.Ecto.Q.Profile

  def index(conn, _params) do
    bloods = Profile.get :blood, Diva.query
    render(conn, "index.html", bloods: bloods, nav: bloods)
  end

  def sub(conn, %{"name" => name} = _params) do
    bloods = Profile.get :blood, Diva.query, name
    render(conn, "index.html", bloods: bloods, nav: Profile.get(:blood, Diva.query))
  end


end
