defmodule Exantenna.Builders.Rss do
  alias Exantenna.Repo
  alias Exantenna.Blog
  alias Exantenna.Services

  alias Exantenna.Redises.Feed
  alias Exantenna.Redises.Item

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

      item = Item.shift(blog.rss)

      case Services.Antenna.add_by(blog, item) do
        {:ok, antenna} ->
          {:ok, antenna}

        # TODO: Move logger to kick module

        {:error, reason} ->
          Logger.error("#{inspect reason} by #{blog.rss}")
          {:error, reason}

        {:warn, msg} ->
          {:warn, msg}

      end

    end
  end
end
