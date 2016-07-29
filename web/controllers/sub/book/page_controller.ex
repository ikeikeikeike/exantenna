defmodule Exantenna.Sub.Book.PageController do
  use Exantenna.Web, :controller

  plug :put_layout, {Exantenna.Sub.Book.LayoutView, "app.html"}

  def index(conn, _params) do
    text(conn, "Book subdomain home page")
  end

end
