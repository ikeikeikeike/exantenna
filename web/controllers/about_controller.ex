defmodule Exantenna.AboutController do
  use Exantenna.Web, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

end
