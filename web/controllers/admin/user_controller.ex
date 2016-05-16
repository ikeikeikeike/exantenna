defmodule Exantenna.Admin.UserController do
  use Exantenna.Web, :controller

  def signup(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    render conn, "signup.html", current_user: current_user
  end

end
