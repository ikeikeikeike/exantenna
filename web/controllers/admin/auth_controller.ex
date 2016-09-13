defmodule Exantenna.Admin.AuthController do
  use Exantenna.Web, :controller

  alias Exantenna.Guardian.UserFromAuth

  alias Exantenna.User
  alias Exantenna.Tmpuser

  alias Exantenna.Auth.User, as: AuthUser
  alias Exantenna.Auth.Changeset, as: AuthCh

  alias Exantenna.SignupMailer
  alias Exantenna.ResetpasswdMailer
  alias Exantenna.Services

  plug Ueberauth
  plug :put_layout, {Exantenna.Admin.LayoutView, "app.html"}

  def signin(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    render conn, "signin.html", current_user: current_user, current_auths: AuthUser.auths(current_user)
  end

  def signup(conn, _params) do
    render conn, "signup.html", changeset: Tmpuser.register_changeset(%Tmpuser{})
  end

  def callback(%Plug.Conn{assigns: %{ueberauth_failure: fails}} = conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)

    conn
    |> put_flash(:error, hd(fails.errors).message)
    |> render("signin.html", current_user: current_user, current_auths: AuthUser.auths(current_user))
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
        |> render("signin.html", current_user: current_user, current_auths: AuthUser.auths(current_user))
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
        |> render("signin.html", current_user: current_user, current_auths: AuthUser.auths(current_user))
    end
  end

  def register(conn, %{"tmpuser" => user_params} = _params) do
    changeset =
      %Tmpuser{}
      |> Tmpuser.register_changeset(user_params)
      |> AuthCh.generate_password(:encrypted_password)

    case Repo.insert(changeset) do
      {:ok, model} ->

        SignupMailer.send_activation model.email,
          admin_auth_url(conn, :confirm_register, model.token)

        msg = gettext("""
        Please make sure that created account successfly.
        Sent confirmation to your email address.
        """)
        conn
        |> put_flash(:info, msg)
        |> redirect(to: admin_user_path(conn, :dashboard))

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Unable to create account")
        |> render("signup.html", changeset: changeset)

    end
  end

  def confirm_register(conn, %{"token" => token} = _params) do
    case Repo.one(Tmpuser.confirmation(:register, Tmpuser, token)) do
      nil -> text conn, gettext("Expires: Token was missing or it is older")

      tmpuser ->
        case Services.User.register(tmpuser) do
          {:error, changeset} ->
            msg =
              """
              Message: %{r}

              Please make sure your email address either it starts registration at one's
              beginnings again or you're able to check your email address from here %{url}.
              """
              |> gettext(r: "#{inspect changeset.errors}", url: admin_auth_url(conn, :resetpasswd, ""))
            text conn, msg

          {:ok, _user} ->
            Repo.delete(tmpuser)

            conn
            |> put_flash(:info, gettext("Your media account created successfuly"))
            |> redirect(to: admin_auth_path(conn, :signin))
        end
    end
  end

  # This is working both login and nologin statement.
  def resetpasswd(%{method: "POST"} = conn, %{"tmpuser" => params}) do
    case Repo.get_by(User, email: params["email"]) do
      nil ->
        conn
        |> put_flash(:error, "Unable to email address")
        |> redirect(to: admin_auth_path(conn, :resetpasswd, ""))

      _model ->
        tmpuser =
          %Tmpuser{}
          |> Tmpuser.resetpasswd_changeset(params)
          |> Repo.insert!

        ResetpasswdMailer.send_activation tmpuser.email,
          admin_auth_url(conn, :resetpasswd, tmpuser.token)

        msg = gettext("""
        You were Successfly!! Please make sure that we sent confirmation
        into your email address for password registration.
        """)
        conn
        |> put_flash(:info, msg)
        |> redirect(to: admin_user_path(conn, :dashboard))
    end
  end

  # This is working both login and nologin statement.
  def resetpasswd(%{method: "PUT"} = conn, %{"token" => token, "tmpuser" => params}) do
    case Repo.one(Tmpuser.confirmation(:resetpasswd, Tmpuser, token)) do
      nil ->
        text conn, gettext("Expires: Token was missing or it was old")

      tmpuser ->
        user = Repo.get_by(User, email: tmpuser.email)

        case Repo.update(User.resetpasswd_changeset(user, params)) do
          {:error, changeset} ->
            render conn, "confirm_resetpasswd.html", changeset: changeset, tmpuser: tmpuser, token: token

          {:ok, _user} ->
            Repo.delete(tmpuser)

            conn
            |> put_flash(:info, gettext("Your new password created successfuly"))
            |> redirect(to: admin_auth_path(conn, :signin))
        end
    end
  end

  # This is working both login and nologin statement.
  def resetpasswd(conn, %{"token" => token}) do
    case Repo.one(Tmpuser.confirmation(:resetpasswd, Tmpuser, token)) do
      nil ->
        text conn, gettext("Expires: Token was missing or it was old")
      tmpuser ->
        render conn, "confirm_resetpasswd.html", changeset: Tmpuser.changeset(tmpuser, %{}), tmpuser: tmpuser, token: token
    end
  end

  # This is working both login and nologin statement.
  def resetpasswd(conn, _params) do
    render conn, "resetpasswd.html", changeset: Tmpuser.register_changeset(%Tmpuser{})
  end

  def logout(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)

    if current_user do
      # This clears the whole session.
      # We could use sign_out(:default) to just revoke this token
      # but I prefer to clear out the session. This means that because we
      # use tokens in two locations - :default and :admin - we need to load it (see above)
      conn
      |> Guardian.Plug.sign_out
      |> put_flash(:info, gettext("Signed out"))
      |> redirect(to: admin_auth_path(conn, :signin))
    else
      conn
      |> put_flash(:info, gettext("Not logged in"))
      |> redirect(to: admin_auth_path(conn, :signin))
    end
  end

end
