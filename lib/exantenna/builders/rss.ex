defmodule Exantenna.Builders.Rss do
  alias Exantenna.Repo
  alias Exantenna.Blog
  alias Exantenna.Services

  alias Exantenna.Redises.Feed

  require Logger

  def feed_into do
    blogs =
      Blog.query
      |> Blog.available
      |> Repo.all

    Enum.map blogs, fn blog ->
      blog = Blog.feed_changeset(blog, Feed.get(blog.rss))

      blog =
        case Repo.insert_or_update(blog) do
          {:ok, blog} ->
            blog

          {:error, cset} ->
            Logger.error("#{inspect cset}")
            blog
        end

      case Services.Antenna.add_by(blog) do
        {:ok, antenna} ->
          {:ok, antenna}

        # TODO: Move logger to kick module

        {:warn, msg} ->
          Logger.warn("#{msg} by #{blog.rss}")
          {:warn, blog, msg}

        {:error, msg} ->
          Logger.error("#{inspect msg} by #{inspect blog}")
          {:error, blog, msg}
      end

    end
  end
end
