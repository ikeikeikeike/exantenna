defmodule Exantenna.Guardian.UserFromAuth do
  alias Exantenna.Repo
  alias Exantenna.User
  alias Exantenna.Authorization

  # alias Ueberauth.Auth

  # def find_or_create(%Auth{provider: :identity} = auth) do
  def find_or_create(auth) do
    case find_authorization(auth) do
      {:error, :not_found} ->
        case find_user(auth) do
          {:error, :not_found} ->
            create_user_and_authorization(auth)
          {:ok, user} ->
            create_authorization(auth, user)
        end
      authz ->
        update_authorization(auth, authz)
    end
  end

  defp find_authorization(auth) do
    case Repo.get_by(Authorization, uid: uid_from_auth(auth), provider: provider_str_from_auth(auth)) do
      nil -> {:error, :not_found}
      authz -> authz |> Repo.preload(:user)
    end
  end

  defp find_user(auth) do
    case Repo.get_by(User, email: email_from_auth(auth)) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end

  defp create_user_and_authorization(auth) do
    Repo.transaction fn ->
      case Repo.insert(%User{email: email_from_auth(auth)}) do
        {:ok, user} ->
          case create_authorization(auth, user) do
            {:ok, user} -> user
            {:error, reason} -> reason
          end
        {:error, reason} ->
          reason
      end
    end
  end

  defp create_authorization(auth, user) do
    authz =
      Ecto.build_assoc(user,
        :authorizations,
          uid: uid_from_auth(auth),
          provider: provider_str_from_auth(auth),
          token: token_from_auth(auth),
          refresh_token: refresh_token_from_auth(auth),
          expires_at: expires_at_from_auth(auth)
      )
    case Repo.insert(authz) do
      {:ok, _authorization} -> {:ok, user}
      {:error, reason} -> {:error, reason}
    end
  end

  defp update_authorization(auth, authz) do
    changeset =
      authz
      |> Authorization.changeset(%{
        token: token_from_auth(auth),
        expires_at: expires_at_from_auth(auth)
      })

    case Repo.update(changeset) do
      {:ok, _} -> {:ok, authz.user}
      {:error, reason} -> {:error, reason}
    end
  end

  # for google oauth2
  defp uid_from_auth(auth), do: auth.uid
  defp email_from_auth(auth), do: auth.info.email
  defp provider_str_from_auth(auth), do: to_string(auth.provider)
  defp token_from_auth(auth), do: auth.credentials.token
  defp refresh_token_from_auth(auth), do: auth.credentials.refresh_token
  defp expires_at_from_auth(auth), do: auth.credentials.expires_at
end
