defmodule Exantenna.Admin.UserController do
  use Exantenna.Web, :controller

  plug AuthPlug.LoginRequired
  plug AdminPlug.AssignUser
  plug :put_layout, {Exantenna.Admin.LayoutView, "app.html"}

  def dashboard(conn, _params) do
    render conn, "dashboard.html"
  end

end
