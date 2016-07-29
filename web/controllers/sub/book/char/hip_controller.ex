defmodule Exantenna.Char.HipController do
  use Exantenna.Web, :controller

  alias Exantenna.Char
  alias Exantenna.Ecto.Q.Profile

  def index(conn, _params) do
    hips = Profile.get :hip, Char.query
    render(conn, "index.html", hips: hips, nav: hips)
  end

  def sub(conn, %{"name" => name} = _params) do
    numeric = List.first String.split(name, "-")

    hips = Profile.get :hip, Diva.query, numeric
    render(conn, "index.html", hips: hips, nav: Profile.get(:hip, Diva.query))
  end

end
