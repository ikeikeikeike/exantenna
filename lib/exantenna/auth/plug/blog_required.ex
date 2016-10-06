defmodule Exantenna.Auth.Plug.BlogRequired do
  import Plug.Conn
  alias Exantenna.User
  alias Exantenna.Blog

  def init(opts), do: opts

  def call(conn, opts) do
    with %User{} = user <- current_user(conn, opts),
         [%Blog{}]      <- Enum.filter(user.blogs, & "#{&1.id}" == conn.params["id"]) do
      conn
    else
      _ -> redirect(conn, opts)
    end
  end

  defp current_user(conn, _ops) do
    case Guardian.Plug.current_resource(conn) do
      %User{} = user -> User.with_blogs(user)
      _ -> false
    end
  end

  defp default_path(conn) do
    Exantenna.Router.Helpers.admin_auth_path(conn, :signin)
  end

  defp redirect(conn, []), do: redirect conn, to: default_path(conn)
  defp redirect(conn, nil), do: redirect conn, to: default_path(conn)
  defp redirect(conn, opts) do
    conn
    |> Phoenix.Controller.redirect(opts)
    |> halt
  end

end
