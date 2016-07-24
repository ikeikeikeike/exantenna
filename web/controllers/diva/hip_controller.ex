defmodule Exantenna.Diva.HipController do
  use Exantenna.Web, :controller

  alias Exantenna.Diva
  alias Exantenna.Ecto.Q.Profile

  def index(conn, _params) do
    hips = Profile.with :hip, Diva.query
    render(conn, "index.html", hips: hips)
  end

end
