defmodule Exantenna.Auth.Plug.LoginRequired do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, opts) do
    if user = current_user(conn, opts) do
      assign(conn, :current_user, user)
    else
      redirect(conn, opts)
    end
  end

  defp current_user(conn, _ops) do
    case Guardian.Plug.current_resource(conn) do
      %Exantenna.User{} = user -> user
      _ -> false
    end
  end

  defp default_path(conn) do
    Exantenna.Router.Helpers.admin_login_path(conn, :login)
  end

  defp redirect(conn, []), do: redirect conn, to: default_path(conn)
  defp redirect(conn, nil), do: redirect conn, to: default_path(conn)
  defp redirect(conn, opts) do
    conn
    |> Phoenix.Controller.redirect(opts)
    |> halt
  end

end
