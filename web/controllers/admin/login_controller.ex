defmodule Exantenna.Admin.LoginController do
  use Exantenna.Web, :controller

  plug :put_layout, {Exantenna.Admin.LayoutView, "app.html"}

  alias Exantenna.Auth.User, as: AuthUser
  alias Exantenna.Tmpuser
  alias Exantenna.Auth.Changeset, as: AuthCh
  alias Exantenna.SignupMailer
  alias Exantenna.Services

  def login(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    render conn, "login.html", current_user: current_user, current_auths: AuthUser.auths(current_user)
  end

  def signup(conn, _params) do
    render conn, "signup.html", changeset: Tmpuser.register_changeset(%Tmpuser{})
  end

  def register(conn, %{"tmpuser" => user_params} = _params) do
    changeset =
      %Tmpuser{}
      |> Tmpuser.register_changeset(user_params)
      |> AuthCh.generate_password(:encrypted_password)

    case Repo.insert(changeset) do
      {:ok, model} ->

        SignupMailer.send_activation model.email,
          admin_login_url(conn, :register_confirm, model.token)

        msg = gettext("""
        Please make sure that created account successfly.
        Sent confirmation to your email address.
        """)
        conn
        |> put_flash(:info, msg)
        |> redirect(to: admin_user_path(conn, :dashboard))

      {:error, changeset} ->
        conn
        |> put_flash(:warn, "Unable to create account")
        |> render("signup.html", changeset: changeset)

    end
  end

  def register_confirm(conn, %{"token" => token} = _params) do
    case Repo.one(Tmpuser.register_confirmation(Tmpuser, token)) do
      nil -> text conn, gettext("Expires: Token was missing or it is older")

      tmpuser ->
        case Services.User.register(tmpuser) do
          {:error, changeset} ->
            msg =
              "Message: %{r}\n Please start registration again at one's beginnings"
              |> gettext(r: "#{inspect changeset.errors}")
            text conn, msg

          {:ok, _user} ->
            Repo.delete(tmpuser)

            conn
            |> put_flash(:info, gettext("Your media account created successfuly"))
            |> redirect(to: admin_login_path(conn, :login))
        end
    end
  end

end
