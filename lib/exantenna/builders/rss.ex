defmodule Exantenna.Builders.Rss do
  alias Exantenna.Es
  alias Exantenna.Repo
  alias Exantenna.Blog
  alias Exantenna.Antenna
  alias Exantenna.Services

  alias Exantenna.Redis.Feed
  alias Exantenna.Redis.Item

  require Logger
  # TODO: Move logger to kickking module like shell

  def feed_into do
    blogs = # Repo.get Blog, 1
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

      antenna =
        case Services.Antenna.add_by(blog, item) do
          {:ok, antenna} ->
            {:ok, antenna}

          {:error, reason} ->
            Logger.error("#{blog.rss}: #{inspect reason} by #{inspect item}")
            {:error, reason}

          {:warn, msg} when is_bitstring(msg) ->
            {:warn, msg}

          msg ->
            {:unkown, msg}

        end

      case antenna do
        %Antenna{} = antenna ->
          Es.Document.put_document(antenna)
          {:ok, antenna}
        msg ->
          msg
      end
    end
  end
end
