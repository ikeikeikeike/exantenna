defmodule Exantenna.Char.HipController do
  use Exantenna.Web, :controller

  alias Exantenna.Char
  alias Exantenna.Ecto.Q.Profile

  def index(conn, _params) do
    hips = Profile.get :hip, Char.query
    render(conn, "index.html", hips: hips)
  end

end
