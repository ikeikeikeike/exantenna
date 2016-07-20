defmodule Exantenna.Sub.Book.PageController do
  use Exantenna.Web, :controller

  def index(conn, _params) do
    text(conn, "Book subdomain home page")
  end

end
