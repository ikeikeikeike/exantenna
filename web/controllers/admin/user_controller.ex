defmodule Exantenna.Admin.UserController do
  use Exantenna.Web, :controller

  plug AuthPlug.LoginRequired
  plug AdminPlug.AssignUser

  def dashboard(conn, _params) do
    render conn, "dashboard.html"
  end

end
