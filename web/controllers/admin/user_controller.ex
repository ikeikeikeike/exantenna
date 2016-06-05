defmodule Exantenna.Admin.UserController do
  use Exantenna.Web, :controller

  def dashboard(conn, _params) do
    render conn, "dashboard.html"
  end

end
