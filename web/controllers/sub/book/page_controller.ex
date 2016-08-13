defmodule Exantenna.Sub.Book.PageController do
  use Exantenna.Web, :controller

  plug DomainPlug.Esparams

  def index(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    render conn, "index.html", current_user: current_user
  end

end
