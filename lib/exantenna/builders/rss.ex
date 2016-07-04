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

    Enum.each blogs, fn blog ->

      blog =
        blog
        |> Blog.feed_changeset(Feed.get(blog.rss))

      blog =
        case Repo.insert_or_update(blog) do
          {:ok, blog} -> blog
          {:error, cset} ->
            Logger.warn("#{inspect blog}: #{inspect cset}")
            blog
        end

      case Services.Antenna.add_by(blog) do
        {:ok, antenna} -> antenna
        {:error, reason} ->
          Logger.warn("#{reason} by #{inspect blog}")
      end

    end
  end
end
