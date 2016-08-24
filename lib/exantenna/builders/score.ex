defmodule Exantenna.Builders.Score do

  import Ecto.Query, only: [from: 1, from: 2]

  alias Exantenna.Blank
  alias Exantenna.Repo
  alias Exantenna.Blog
  alias Exantenna.Score
  alias Exantenna.Score.Inlog

  require Logger

  # Launch this per 11 min (in 0, 11, 22, 33, 44, 55)
  def inscore_into([]), do: inscore_into
  def inscore_into do
    blogs = Repo.all Blog

    table = {Score.name_table(Blog), Score}

    inlogs =
      blogs
      |> Enum.map(&(&1.url))
      |> Inlog.resource
      |> Inlog.scoring

    Enum.each blogs, fn blog ->

      count = inlogs[blog.url]

      unless Blank.blank?(count) do

        query =
          from s in table,
            where: s.assoc_id == ^blog.id

        scores =
          query
          |> Repo.all
          |> make_scores(count, blog)

        require IEx; IEx.pry

        Repo.transaction fn ->
          changeset =
            blog
            |> Repo.preload(:scores)
            |> Blog.score_changeset(%{"scores" => scores})

          require IEx; IEx.pry

          case Repo.update(changeset) do
            {:error, reason} ->
              Logger.error("Build daily score: #{inspect reason}")
              Repo.rollback(reason)

            {_, blog} ->
              blog
          end
        end
      end
    end
  end

  defp make_scores([], count, blog) do
    [
      %{
        "assoc_id" => blog.id,
        "name" => Score.const_in_daily,
        "count" => count
      }, %{
        "assoc_id" => blog.id,
        "name" => Score.const_in_weekly,
        "count" => count
      }, %{
        "assoc_id" => blog.id,
        "name" => Score.const_in_monthly,
        "count" => count
      }, %{
        "assoc_id" => blog.id,
        "name" => Score.const_in_quarterly,
        "count" => count
      }, %{
        "assoc_id" => blog.id,
        "name" => Score.const_in_biannually,
        "count" => count
      }, %{
        "assoc_id" => blog.id,
        "name" => Score.const_in_yearly,
        "count" => count
      }, %{
        "assoc_id" => blog.id,
        "name" => Score.const_in_totally,
        "count" => count
      }
    ]
  end

  defp make_scores(scores, count, _blog) when is_list(scores) do
    dt = Timex.DateTime.now

    Enum.reduce scores, [], fn score, acc ->
      param = %{
        "assoc_id" => score.assoc_id,
        "name" => score.name,
        "count" => sum(score, dt, count)
      }

      acc ++ [param]
    end
  end

  defp sum(%Score{} = model, bool, num) when is_boolean(bool) and is_integer(num) do
    case bool do
      true  ->
        struct model, [count: 0]
      false ->
        struct model, [count: model.count + num]
    end
  end
  @const_hourly Score.const_in_hourly
  defp sum(%Score{name: @const_hourly} = model, dt, count) do
    sum model, model.updated_at > Timex.end_of_hour(dt), count
  end
  @const_daily Score.const_in_daily
  defp sum(%Score{name: @const_daily} = model, dt, count) do
    sum model, model.updated_at > Timex.end_of_day(dt), count
  end
  @const_weekly Score.const_in_weekly
  defp sum(%Score{name: @const_weekly} = model, dt, count) do
    sum model, model.updated_at > Timex.end_of_week(dt), count
  end
  @const_monthly Score.const_in_monthly
  defp sum(%Score{name: @const_monthly} = model, dt, count) do
    sum model, model.updated_at > Timex.end_of_month(dt), count
  end
  @const_quarterly Score.const_in_quarterly
  defp sum(%Score{name: @const_quarterly} = model, dt, count) do
    sum model, model.updated_at > Timex.end_of_quarter(dt), count
  end
  @const_biannually Score.const_in_biannually
  defp sum(%Score{name: @const_biannually} = model, dt, count) do
    sum model, model.updated_at > end_of_biannual(dt), count
  end
  @const_yearly Score.const_in_yearly
  defp sum(%Score{name: @const_yearly} = model, dt, count) do
    sum model, model.updated_at > Timex.end_of_year(dt), count
  end
  @const_totally Score.const_in_totally
  defp sum(%Score{name: @const_totally} = model, dt, count) do
    sum model, false, count
  end

  def end_of_hour(dt) do
    Timex.DateTime.from({{dt.year, dt.month, dt.day}, {dt.hour, 59, 59}})
  end

  def end_of_biannual(dt) do
    case dt.month do
      m when m in 1..6  -> Timex.end_of_month Timex.DateTime.from({dt.year, 6, 1})
      m when m in 7..12 -> Timex.end_of_month Timex.DateTime.from({dt.year, 12, 1})
    end
  end

end
