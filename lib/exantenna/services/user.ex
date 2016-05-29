defmodule Exantenna.Services.User do
  alias Exantenna.Repo
  alias Exantenna.Blog
  alias Exantenna.User
  alias Exantenna.Tmpuser

  require Logger

  def register(%Tmpuser{} = tmpuser) do
    Repo.transaction fn ->
      params = Map.from_struct(tmpuser)

      case Repo.insert(User.register_changeset(%User{}, params)) do
        {:error, changeset} -> Repo.rollback(changeset)
        {:ok, user} ->
          params = Map.merge params, %{user_id: user.id}

          case Repo.insert(Blog.register_changeset(%Blog{}, params)) do
            {:error, changeset} -> Repo.rollback(changeset)
            {:ok, _blog} -> user
          end
      end
    end
  end
end
