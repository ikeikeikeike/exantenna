defmodule Exantenna.Toon.WorksController do
  use Exantenna.Web, :controller

  alias Exantenna.Toon
  alias Exantenna.Ecto.Q.Profile

  def index(conn, _params) do
    letters = Profile.get :works, Toon.query
    render(conn, "index.html", letters: letters, nav: letters)
  end

  def sub(conn, %{"name" => name} = _params) do
    letters = Profile.get :works, Toon.query, name
    render(conn, "index.html", letters: letters, nav: Profile.get(:works, Toon.query))
  end

end
