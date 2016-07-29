defmodule Exantenna.Char.AtozController do
  use Exantenna.Web, :controller

  alias Exantenna.Char
  alias Exantenna.Ecto.Q.Profile

  def index(conn, _params) do
    letters = Profile.get(:atoz, Char.query)
    render(conn, "index.html", letters: letters)
  end

end
