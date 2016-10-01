defmodule Exantenna.Builders.Rss do
  alias Exantenna.Repo
  alias Exantenna.Blog
  alias Exantenna.Score
  alias Exantenna.Antenna
  alias Exantenna.Services
  alias Exantenna.Penalty

  alias Exantenna.Redis.Feed
  alias Exantenna.Redis.Item

  import Ecto.Query, only: [from: 1, from: 2]
  require Logger
  # TODO: Move logger to kickking module that's like shell

  """
  - For begginer
  - For everything
  - For today's received access from blog
  - Someday: for month's received access from blog
  - For dont have penalty
  """

  def feed_into, do: feed_into :everything
  def feed_into(:everything) do
    Blog.query
    |> Blog.everything
    |> availabled_shuffle
  end

  def feed_into(:begginer) do
    Blog.query
    |> Blog.begginer
    |> availabled_shuffle
  end

  def feed_into(:no_penalty) do
    Blog.query
    |> Blog.no_penalties
    |> availabled_shuffle
  end

  def feed_into(:todays_access) do
    blogs =
      Blog.query
      |> Blog.everything
      |> Repo.all

    allows =
      blogs
      |> Enum.filter(fn b ->
        case Score.get_in_daily(b.scores) do
          %Score{} = score ->
            0 < score.count
          _ ->
            false
        end
      end)
      |> Enum.map(& &1.id)

    queryable =
      from f in Blog.query,
        where: f.id in ^allows

    queryable
    |> availabled_shuffle
  end

  def feed_into(:months_access) do
    # not implemented
  end

  defp availabled_shuffle(queryable) do
    blogs =
      queryable
      |> Blog.available
      |> Repo.all
      |> Enum.shuffle  # TODO: shuffle logic

    ExSentry.capture_exceptions fn ->
      feed_into blogs
    end
  end

  def feed_into(blogs) when is_list(blogs) do
    Enum.each blogs, fn blog ->
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

        {:error, reason} ->
          Logger.error("#{blog.rss}: #{inspect reason} by #{inspect item}")
          {:error, reason}

        {:warn, msg} when is_bitstring(msg) ->
          {:warn, msg}

        msg ->
          {:unkown, msg}

      end
    end
  end
end
