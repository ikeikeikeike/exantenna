defmodule Exantenna.Builders.Rss do
  alias Exantenna.Repo
  alias Exantenna.Blog
  alias Exantenna.Blank
  alias Exantenna.Services

  import Logger, only: [warn: 1]

  def feed_into do
    blogs = Repo.all Blog.query

    Enum.each blogs, fn b ->
      feed =
        with true <- ! Blank.blank?(b.rss), feed = Scrape.feed(b.rss),
             true <- ! Blank.blank?(feed), true <- length(feed) > 0,
          do: feed

      case feed do
        [%{}] ->

          meta = []

          case Services.Blog.update_by_feedmeta(b, meta) do
            {:ok, blog} -> blog
            {:ng, rson} -> warn("#{inspect b}: #{rson}")
          end

          case Services.Antenna.add_by_feed(feed) do
            {:ok, antenna} -> antenna
            {:ng, rson} -> warn("#{rson} by #{inspect b} and #{feed}")
          end

        _ ->
          Logger.warn("Warn #{inspect b} rss feed was blank")
      end

    end
  end
end
