defmodule Exantenna.Admin.UserController do
  use Exantenna.Web, :controller
  alias Exantenna.Tmpuser
  alias Exantenna.Auth.Changeset, as: Authc

  def signup(conn, _params) do
    render conn, "signup.html", changeset: Tmpuser.register_changeset(%Tmpuser{})
  end

  def register(conn, %{"tmpuser" => user_params} = _params) do
    changeset =
      %Tmpuser{}
      |> Tmpuser.register_changeset(user_params)
      |> Authc.generate_password(:encrypted_password)

    case Repo.insert(changeset) do
      {:ok, _model} ->
        conn
        |> put_flash(:info, "Your account was created")
        |> redirect(to: "/")
      {:error, changeset} ->
        conn
        |> put_flash(:warn, "Unable to create account")
        |> render("signup.html", changeset: changeset)
    end
  end

end
