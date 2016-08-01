defmodule Exantenna.Builders.Score do

  alias Exantenna.Repo
  alias Exantenna.Blog
  alias Exantenna.Score.Inlog

  require Logger

  def inscore_into do
    blogs = Repo.all Blog

    resource =
      blogs
      |> Enum.map(&(&1.url))
      |> Inlog.resource

    scores = Inlog.scoring resource

    Enum.each blogs, fn blog ->

      if score = scores[blog.url] do
        params = %{"indaily" => %{"count" => score}}
        cset = Blog.daily_changeset(blog, params)

        case Repo.insert_or_update(cset) do
          {:error, cset} ->
            Logger.error("Build daily score: #{inspect cset}")

          {:ok, struct}  ->
            struct
        end
      end
    end
  end

end
