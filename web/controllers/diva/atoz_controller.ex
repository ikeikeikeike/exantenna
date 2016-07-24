defmodule Exantenna.Diva.AtozController do
  use Exantenna.Web, :controller

  alias Exantenna.Diva
  alias Exantenna.Ecto.Q.Profile

  def index(conn, _params) do
    letters = Profile.with(:atoz, Diva.query)
    render(conn, "index.html", letters: letters)
  end

end
