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

  def feed_into([]), do: feed_into :everything
  def feed_into(:everything) do
    blogs = # Repo.get Blog, 1
      Blog.query
      |> Blog.available
      |> Repo.all
      |> Enum.shuffle  # TODO: shuffle logic
      |> feed_into
  end

  def feed_into(:begginer) do
    queryable =
      from f in Blog.query,
        join: j in Penalty,
        where: j.penalty == ^Penalty.const_beginning

    blogs =
      queryable
      |> Blog.available
      |> Repo.all
      |> Enum.shuffle  # TODO: shuffle logic
      |> feed_into
  end

  def feed_into(:no_penalty) do
    allows = [
      Penalty.const_beginning,
      Penalty.const_none,
      Penalty.const_soft,
    ]

    queryable =
      from f in Blog.query,
        join: j in Penalty,
        where: j.penalty in ^allows

    blogs =
      queryable
      |> Blog.available
      |> Repo.all
      |> Enum.shuffle  # TODO: shuffle logic
      |> feed_into
  end

  def feed_into(:todays_access) do
    blogs = Repo.all Blog.query

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

    blogs =
      queryable
      |> Blog.available
      |> Repo.all
      |> Enum.shuffle  # TODO: shuffle logic
      |> feed_into
  end

  def feed_into(:months_access) do
    # not implemented
  end

  def feed_into(blogs) when is_list(blogs) do
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
