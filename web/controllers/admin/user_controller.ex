defmodule Exantenna.Admin.UserController do
  use Exantenna.Web, :controller

  alias Exantenna.User
  alias Exantenna.Tmpuser
  alias Exantenna.ChangemailMailer

  plug AuthPlug.LoginRequired
  plug AuthPlug.AssignUser
  plug :put_layout, {Exantenna.Admin.LayoutView, "app.html"}

  def dashboard(conn, _params) do
    render conn, "dashboard.html"
  end

  def changemail(%{method: "POST"} = conn, %{"tmpuser" => params}) do
    changeset =
      %Tmpuser{}
      |> Tmpuser.changemail_changeset(params)

    case Repo.insert(changeset) do
      {:ok, model} ->

        ChangemailMailer.send_activation model.email,
          admin_user_url(conn, :changemail, model.token)

        msg = gettext("""
        Successfly!! Please make sure that we sent activation
        for email registration into your new email address.
        """)
        conn
        |> put_flash(:info, msg)
        |> redirect(to: admin_user_path(conn, :changemail))

      {:error, changeset} ->
        conn
        |> put_flash(:warn, "Unable to create account")
        |> render("changemail.html", changeset: changeset)
    end
  end

  def changemail(%{method: "PUT"} = conn, %{"token" => token, "tmpuser" => params}) do
    case Repo.one(Tmpuser.confirmation(:changemail, Tmpuser, token)) do
      nil ->
        text conn, gettext("Expires: Token was missing or it was old")

      tmpuser ->
        user = conn.assigns.user

        case Repo.update(User.changemail_changeset(user, params)) do
          {:error, changeset} ->
            render conn, "confirm_changemail.html", changeset: changeset, tmpuser: tmpuser, token: token

          {:ok, _user} ->
            Repo.delete(tmpuser)

            conn
            |> put_flash(:info, gettext("Your email address is creating successfuly"))
            |> redirect(to: admin_user_path(conn, :dashboard))
        end
    end
  end

  def changemail(conn, %{"token" => token} = _params) do
    case Repo.one(Tmpuser.confirmation(:changemail, Tmpuser, token)) do
      nil ->
        text conn, gettext("Expires: Token was missing or it was old")
      tmpuser ->
        render conn, "confirm_changemail.html", changeset: Tmpuser.changeset(tmpuser, %{}), tmpuser: tmpuser, token: token
    end
  end

  def changemail(conn, _params) do
    render conn, "changemail.html", changeset: Tmpuser.register_changeset(%Tmpuser{})
  end

end
