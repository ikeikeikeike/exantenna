defmodule Exantenna.Auth.User do
  alias Exantenna.Repo
  alias Exantenna.User

  alias Comeonin.Pbkdf2

  def check_password(%Ueberauth.Auth{provider: :identity} = auth) do
    case Repo.get_by(User, email: auth.info.email) do
      nil -> {:error, :not_found}
      user ->
        password = auth.credentials.other[:password]
        if Pbkdf2.checkpw(password, user.encrypted_password) do
          {:ok, user}
        else
          {:error, :not_found}
        end
    end
  rescue
    _e in MatchError ->
      {:error, :not_found}
    _e in ArgumentError ->
      {:error, :not_found}
  end

  def auths(nil), do: []
  def auths(%Exantenna.User{} = user) do
    Ecto.Model.assoc(user, :authorizations)
      |> Repo.all
      |> Enum.map(&(&1.provider))
  end

end
