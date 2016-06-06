defmodule Exantenna.Admin.UserController do
  use Exantenna.Web, :controller

  plug AuthPlug.LoginRequired

  def dashboard(conn, _params) do
    render conn, "dashboard.html"
  end

  def blogs(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    render conn, "blogs.html", user: Repo.preload(current_user, blogs: :verifiers)
  end

end
