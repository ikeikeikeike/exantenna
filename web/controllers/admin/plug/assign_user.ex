defmodule Exantenna.Admin.Plug.AssignUser do
  import Plug.Conn
  alias Exantenna.User

  def init(opts), do: opts
  def call(conn, _opts) do
    assign(conn, :user, User.with_blogs(conn.assigns.current_user))
  end

end
