defmodule Exantenna.Admin.BlogController do
  use Exantenna.Web, :controller
  alias Exantenna.User
  alias Exantenna.Blog

  plug AuthPlug.LoginRequired

  def index(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    render conn, "index.html", user: User.with_blogs(current_user)
  end

  def new(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    render conn, "new.html", user: User.with_blogs(current_user), changeset: Blog.changeset(%Blog{}), blog: nil
  end

  def edit(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    render conn, "edit.html", user: User.with_blogs(current_user), changeset: Blog.changeset(%Blog{}), blog: nil
  end

end
