defmodule Exantenna.Diva.AtozController do
  use Exantenna.Web, :controller

  alias Exantenna.Diva
  alias Exantenna.Ecto.Q.Profile

  def index(conn, _params) do
    letters = Profile.get :atoz, Diva, Diva.query
    render(conn, "index.html", letters: letters, nav: letters)
  end

  def sub(conn, %{"name" => name} = _params) do
    letters = Profile.get :atoz, Diva, Diva.query, name
    render(conn, "index.html", letters: letters, nav: Profile.get(:atoz, Diva, Diva.query))
  end

end
