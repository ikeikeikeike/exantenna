defmodule Exantenna.Sub.Video.PageController do
  use Exantenna.Web, :controller

  def index(conn, _params) do
    text(conn, "Video subdomain home page")
  end

end
