defmodule Exantenna.Builders.Score do

  import Ecto.Query, only: [from: 1, from: 2]

  alias Exantenna.Blank
  alias Exantenna.Repo
  alias Exantenna.Blog
  alias Exantenna.Score
  alias Exantenna.Score.Inlog

  require Logger

  # TODO: To be:  Repo.stream(chunk_size: 10)
  # Launch this per a hour or it also launchs before summary batch.
  def inscore_into do
    blogs = Repo.all Blog

    table = {Score.name_table(Blog), Score}

    inlogs =
      blogs
      |> Enum.map(& &1.url)
      |> Enum.filter(& ! Blank.blank?(&1))
      |> Inlog.resource
      |> Inlog.scoring

    Enum.map(blogs, fn blog ->
      count = inlogs[blog.url] || 0

      query =
        from s in table,
          where: s.assoc_id == ^blog.id

      scores =
        query
        |> Repo.all
        |> make_scores(count, blog)

      Repo.transaction fn ->
        changeset =
          blog
          |> Repo.preload(:scores)
          |> Blog.score_changeset(%{"scores" => scores})

        case Repo.update(changeset) do
          {:error, reason} ->
            Logger.error("Build daily score: #{inspect reason}")
            Repo.rollback(reason)

          {_, blog} ->
            blog
        end
      end
    end)
    |> Enum.filter(fn trans ->
      case trans do
        {:ok, %Blog{}} -> true
        _              -> false
      end
    end)
    |> Enum.map(fn trans ->
      {:ok, blog} = trans
       blog
    end)
  end

  defp make_scores(scores, count, blog) when is_list(scores) do
    template =
      [
        %{
          "assoc_id" => blog.id,
          "name" => Score.const_in_hourly,
          "count" => count
        }, %{
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

    dt = Timex.DateTime.now

    Enum.reduce template, [], fn param, acc ->
      exists =
        Enum.filter scores, fn score ->
          param["name"] == score.name
        end

      param =
        case exists do
          [score] ->
            %{
              "assoc_id" => score.assoc_id,
              "name" => score.name,
              "count" => sum(score, dt, count)
            }
          []      ->
            param
        end

      acc ++ [param]
    end
  end

  defp sum(%Score{} = model, left, right, num) when is_integer(num) do
    case Timex.compare(left, right) do
      1  ->
        model.count + num
      0  ->
        0
      -1 ->
        0
    end
  end
  @const_totally Score.const_in_totally
  defp sum(%Score{name: @const_totally} = model, dt, count) do
    model.count + count
  end
  @const_hourly Score.const_in_hourly
  defp sum(%Score{name: @const_hourly} = model, dt, count) do
    sum model, end_of_hour(model.updated_at), dt, count
  end
  @const_daily Score.const_in_daily
  defp sum(%Score{name: @const_daily} = model, dt, count) do
    sum model, Timex.end_of_day(model.updated_at), dt, count
  end
  @const_weekly Score.const_in_weekly
  defp sum(%Score{name: @const_weekly} = model, dt, count) do
    sum model, Timex.end_of_week(model.updated_at), dt, count
  end
  @const_monthly Score.const_in_monthly
  defp sum(%Score{name: @const_monthly} = model, dt, count) do
    sum model, Timex.end_of_month(model.updated_at), dt, count
  end
  @const_quarterly Score.const_in_quarterly
  defp sum(%Score{name: @const_quarterly} = model, dt, count) do
    sum model, Timex.end_of_quarter(model.updated_at), dt, count
  end
  @const_biannually Score.const_in_biannually
  defp sum(%Score{name: @const_biannually} = model, dt, count) do
    sum model, end_of_biannual(model.updated_at), dt, count
  end
  @const_yearly Score.const_in_yearly
  defp sum(%Score{name: @const_yearly} = model, dt, count) do
    sum model, Timex.end_of_year(model.updated_at), dt, count
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
