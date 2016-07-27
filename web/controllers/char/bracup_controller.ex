defmodule Exantenna.Char.BracupController do
  use Exantenna.Web, :controller

  alias Exantenna.Char
  alias Exantenna.Ecto.Q.Profile

  def index(conn, _params) do
    bracups = Profile.with :bracup, Char.query
    render(conn, "index.html", bracups: bracups)
  end

  def cup(conn, %{"cup" => cup} = _params) do
    bracups = Profile.with :bracup, Char.query, cup
    render(conn, "index.html", bracups: bracups, nav: Profile.with(:bracup, Char.query))
  end


end
