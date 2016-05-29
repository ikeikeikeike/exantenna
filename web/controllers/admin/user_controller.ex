defmodule Exantenna.Admin.UserController do
  use Exantenna.Web, :controller

  alias Exantenna.Tmpuser
  alias Exantenna.Auth.Changeset, as: Authc
  alias Exantenna.SignupMailer
  alias Exantenna.Router.Helpers
  alias Exantenna.Services

  def signup(conn, _params) do
    render conn, "signup.html", changeset: Tmpuser.register_changeset(%Tmpuser{})
  end

  def register(conn, %{"tmpuser" => user_params} = _params) do
    changeset =
      %Tmpuser{}
      |> Tmpuser.register_changeset(user_params)
      |> Authc.generate_password(:encrypted_password)

    case Repo.insert(changeset) do
      {:ok, model} ->

        SignupMailer.send_activation model.email,
          Helpers.admin_user_url(:register_confirm, model.token)

        msg = gettext("""
        Please make sure that created account successfly.
        Sent confirmation to your email address.
        """)
        conn
        |> put_flash(:info, msg)
        |> redirect(to: "/")

      {:error, changeset} ->
        conn
        |> put_flash(:warn, "Unable to create account")
        |> render("signup.html", changeset: changeset)

    end
  end

  def register_confirm(conn, %{"token" => token} = _params) do
    case Repo.one(Tmpuser.register_confirmation_query(token)) do
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
            |> redirect(to: Helpers.admin_auth_path(:login))
        end
    end
  end

end
