defmodule Exantenna.Diva.HeightController do
  use Exantenna.Web, :controller

  alias Exantenna.Diva
  alias Exantenna.Ecto.Q.Profile

  def index(conn, _params) do
    heights = Profile.with :height, Diva.query
    render(conn, "index.html", heights: heights)
  end

end
