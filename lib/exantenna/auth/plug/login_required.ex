defmodule Exantenna.Auth.Plug.LoginRequired do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, opts) do
    if current_user = already_login?(conn, opts) do
      assign(conn, :current_user, current_user)
    else
      redirect(conn, opts)
    end
  end

  defp already_login?(conn, _ops) do
    case Guardian.Plug.current_resource(conn) do
      %Exantenna.User{} = user -> user
      _ -> false
    end
  end

  defp default_path do
    Exantenna.Router.Helpers.admin_auth_path(Exantenna.Endpoint, :login, "identity")
  end

  defp redirect(conn, []), do: redirect conn, to: default_path
  defp redirect(conn, nil), do: redirect conn, to: default_path
  defp redirect(conn, opts) do
    conn
    |> Phoenix.Controller.redirect(opts)
    |> halt
  end

end
