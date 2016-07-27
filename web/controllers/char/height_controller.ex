defmodule Exantenna.Char.HeightController do
  use Exantenna.Web, :controller

  alias Exantenna.Char
  alias Exantenna.Ecto.Q.Profile

  def index(conn, _params) do
    heights = Profile.with :height, Char.query
    render(conn, "index.html", heights: heights)
  end

end
