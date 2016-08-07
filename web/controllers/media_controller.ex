defmodule Exantenna.MediaController do
  use Exantenna.Web, :controller

  def index(conn, params) do
    render(conn, "index.html")
  end

  def rss(conn, params) do
    render(conn, "rss.html")
  end

  def parts(conn, params) do
    render(conn, "parts.html")
  end

  def links(conn, params) do
    render(conn, "links.html")
  end

end
