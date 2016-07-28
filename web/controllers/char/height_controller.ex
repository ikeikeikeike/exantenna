defmodule Exantenna.Char.HeightController do
  use Exantenna.Web, :controller

  alias Exantenna.Char
  alias Exantenna.Ecto.Q.Profile

  def index(conn, _params) do
    heights = Profile.get :height, Char.query
    render(conn, "index.html", heights: heights, nav: heights)
  end

  def sub(conn, %{"name" => name} = _params) do
    numeric = List.first String.split(name, "-")

    heights = Profile.get :height, Diva.query, numeric
    render(conn, "index.html", heights: heights, nav: Profile.get(:height, Diva.query))
  end

end
