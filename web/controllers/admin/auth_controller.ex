defmodule Exantenna.Admin.AuthController do
  use Exantenna.Web, :controller
  alias Exantenna.Guardian.UserFromAuth
  alias Exantenna.Auth.User, as: AuthUser

  plug Ueberauth
  plug :put_layout, {Exantenna.Admin.LayoutView, "app.html"}

  def callback(%Plug.Conn{assigns: %{ueberauth_failure: fails}} = conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)

    conn
    |> put_flash(:error, hd(fails.errors).message)
    |> render("login.html", current_user: current_user, current_auths: AuthUser.auths(current_user))
  end

  def callback(%Plug.Conn{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)

    case UserFromAuth.find_or_create(auth) do
      {:ok, user} ->
        conn
        |> put_flash(:info, gettext("Signed in as %{email}", email: user.email))
        |> Guardian.Plug.sign_in(user, :token, perms: %{default: Guardian.Permissions.max})
        |> redirect(to: admin_user_path(conn, :dashboard))
      {:error, reason} ->
        conn
        |> put_flash(:error, gettext("Could not authenticate. %{reason}", reason: reason))
        |> render("login.html", current_user: current_user, current_auths: AuthUser.auths(current_user))
    end
  end

  def identity_callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
    current_user = Guardian.Plug.current_resource(conn)

    case AuthUser.check_password(auth) do
      {:ok, _user} ->
        auth = struct(auth, [credentials: Map.merge(auth.credentials,
          %{token: Ecto.UUID.generate,
            expires_at: Timex.to_unix(Timex.shift(Timex.DateTime.now, days: 2))}
        )])

        struct(conn, [assigns: %{ueberauth_auth: auth}])
        |> callback(params)
      {:error, reason} ->
        conn
        |> put_flash(:error, gettext("Could not authenticate. %{reason}", reason: reason))
        |> render("login.html", current_user: current_user, current_auths: AuthUser.auths(current_user))
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
      |> put_flash(:info, gettext("Signed out"))
      |> redirect(to: admin_login_path(conn, :login))
    else
      conn
      |> put_flash(:info, gettext("Not logged in"))
      |> redirect(to: admin_login_path(conn, :login))
    end
  end

end
