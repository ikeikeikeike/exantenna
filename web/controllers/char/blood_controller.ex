defmodule Exantenna.Char.BloodController do
  use Exantenna.Web, :controller

  alias Exantenna.Char
  alias Exantenna.Ecto.Q.Profile

  def index(conn, _params) do
    bloods = Profile.get :blood, Char.query
    render(conn, "index.html", bloods: bloods, nav: bloods)
  end

  def sub(conn, %{"name" => name} = _params) do
    bloods = Profile.get :blood, Char.query, name
    render(conn, "index.html", bloods: bloods, nav: Profile.get(:blood, Char.query))
  end


end
