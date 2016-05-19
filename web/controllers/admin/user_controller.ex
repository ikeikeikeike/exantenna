defmodule Exantenna.Admin.UserController do
  use Exantenna.Web, :controller
  alias Exantenna.Tmpuser

  def signup(conn, _params) do
    render conn, "signup.html", changeset: Tmpuser.register_changeset(%Tmpuser{})
  end

  def register(conn, %{"tmpuser" => user_params} = _params) do
    changeset =
      Tmpuser.register_changeset(%Tmpuser{}, user_params)

    if changeset.valid? do
      changeset
      |> Tmpuser.generate_password
      |> Exantenna.Repo.insert

      conn
      |> put_flash(:info, "Your account was created")
      |> redirect(to: "/")

    else
      conn
      |> put_flash(:warn, "Unable to create account")
      |> render("signup.html", changeset: changeset)
    end
  end

end
