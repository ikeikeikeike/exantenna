defmodule Exantenna.Admin.UserController do
  use Exantenna.Web, :controller

  plug AuthPlug.LoginRequired

  def dashboard(conn, _params) do
    render conn, "dashboard.html"
  end

  def blogs(conn, _params) do
    render conn, "blogs.html"
  end

end
