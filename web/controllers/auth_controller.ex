defmodule Exantenna.AuthController do
  use Exantenna.Web, :controller

  alias Exantenna.Guardian.UserFromAuth

  plug Ueberauth

  def login(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    render conn, "login.html", current_user: current_user, current_auths: auths(current_user)
  end

  def callback(%Plug.Conn{assigns: %{ueberauth_failure: fails}} = conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)

    conn
    |> put_flash(:error, hd(fails.errors).message)
    |> render("login.html", current_user: current_user, current_auths: auths(current_user))
  end

  def callback(%Plug.Conn{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)

    case UserFromAuth.find_or_create(auth) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Signed in as #{user.email}")
        |> Guardian.Plug.sign_in(user, :token, perms: %{default: Guardian.Permissions.max})
        |> redirect(to: page_path(conn, :index))
      {:error, reason} ->
        conn
        |> put_flash(:error, "Could not authenticate. Error: #{reason}")
        |> render("login.html", current_user: current_user, current_auths: auths(current_user))
    end
  end

  def logout(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)

    if current_user do
      conn
      # This clears the whole session.
      # We could use sign_out(:default) to just revoke this token
      # but I prefer to clear out the session. This means that because we
      # use tokens in two locations - :default and :admin - we need to load it (see above)
      |> Guardian.Plug.sign_out
      |> put_flash(:info, "Signed out")
      |> redirect(to: "/")
    else
      conn
      |> put_flash(:info, "Not logged in")
      |> redirect(to: "/")
    end
  end

  defp auths(nil), do: []
  defp auths(%Exantenna.User{} = user) do
    Ecto.Model.assoc(user, :authorizations)
      |> Repo.all
      |> Enum.map(&(&1.provider))
  end
end
