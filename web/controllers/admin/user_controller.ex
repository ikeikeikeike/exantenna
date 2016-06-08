defmodule Exantenna.Admin.UserController do
  use Exantenna.Web, :controller
  alias Exantenna.User

  plug AuthPlug.LoginRequired

  def dashboard(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    render conn, "dashboard.html", user: User.with_blogs(current_user)
  end

end
