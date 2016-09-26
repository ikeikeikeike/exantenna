defmodule Exantenna.Builders.Penalty do
  alias Exantenna.Repo
  alias Exantenna.Blog
  alias Exantenna.Score
  alias Exantenna.Antenna
  alias Exantenna.Penalty

  import Ecto.Query, only: [from: 1, from: 2]
  require Logger

  @const_none Penalty.const_none
  @const_soft Penalty.const_soft
  @const_hard Penalty.const_hard
  @const_ban Penalty.const_ban

  # Going up to one level penalty if the access doesn't make from blog in a whole day.
  def penalty(:up) do

    queryable = from f in Blog.query,
        join: j in assoc(f, :scores),
        where: j.assoc_id == f.id
           and j.count <= 0
           and j.name == ^Score.const_in_daily

    queryable
    |> Repo.all
    |> Enum.each(fn blog ->

      model =
        case blog.penalty do
          %Penalty{penalty: @const_none} ->
            %{blog.penalty | penalty: @const_soft}

          %Penalty{penalty: @const_soft} ->
            %{blog.penalty | penalty: @const_hard}

          %Penalty{penalty: penalty} ->
            %{blog.penalty | penalty: penalty}
        end

      evolve blog, Map.from_struct(model)
    end)
  end

  # Going down to one level penalty if the access makes from blog in a whole day.
  def penalty(:down) do

    queryable = from f in Blog.query,
        join: j in assoc(f, :scores),
        where: j.assoc_id == f.id
           and j.count > 0
           and j.name == ^Score.const_in_daily

    queryable
    |> Repo.all
    |> Enum.each(fn blog ->

      model =
        case blog.penalty do
          %Penalty{penalty: @const_soft} ->
            %{blog.penalty | penalty: @const_none}

          %Penalty{penalty: @const_hard} ->
            %{blog.penalty | penalty: @const_soft}

          %Penalty{penalty: penalty} ->
            %{blog.penalty | penalty: penalty}
        end

      evolve blog, Map.from_struct(model)
    end)
  end

  # Going up to ban level penalty if the access doesnt make from blog in a week.
  def penalty(:ban) do

    queryable = from f in Blog.query,
        join: j in assoc(f, :scores),
        where: j.assoc_id == f.id
           and j.count <= 0
           and j.name == ^Score.const_in_weekly

    queryable
    |> Repo.all
    |> Enum.each(fn blog ->

      model =
        case blog.penalty do
          %Penalty{penalty: @const_hard} ->
            %{blog.penalty | penalty: @const_ban}

          %Penalty{penalty: penalty} ->
            %{blog.penalty | penalty: penalty}
        end

      evolve blog, Map.from_struct(model)
    end)
  end

  # Going down to hard level penalty if the access makes from blog in a week.
  def penalty(:left) do

    queryable = from f in Blog.query,
        join: j in assoc(f, :scores),
        where: j.assoc_id == f.id
           and j.count > 0
           and j.name == ^Score.const_in_weekly

    queryable
    |> Repo.all
    |> Enum.each(fn blog ->

      model =
        case blog.penalty do
          %Penalty{penalty: @const_ban} ->
            %{blog.penalty | penalty: @const_hard}

          %Penalty{penalty: penalty} ->
            %{blog.penalty | penalty: penalty}
        end

      evolve blog, Map.from_struct(model)
    end)
  end

  def penalty(:begin) do
    dt = Timex.DateTime.now

    queryable = from f in Blog.query,
        join: j in assoc(f, :penalty),
        where: j.assoc_id == f.id
           and j.penalty == ^Penalty.const_beginning

    queryable
    |> Repo.all
    |> Enum.each(fn blog ->
      param =
        case blog.penalty do
          nil     ->
            %{assoc_id: blog.id}  # Default: penalty=beginning right now.

          model ->
            honeymoon =
              Timex.shift model.inserted_at, days: 14

            case Timex.compare(honeymoon, dt) do
              1  ->
                Map.from_struct model
              0  ->
                Map.from_struct model
              -1 ->
                Map.from_struct struct(model, [penalty: Penalty.const_none])
            end
        end

      evolve blog, param
    end)
  end

  def penalty(:nothing) do
    dt = Timex.DateTime.now

    queryable =
      from f in Blog.query,
        left_join: j in assoc(f, :penalty),
        where: is_nil(j.assoc_id)

    queryable
    |> Repo.all
    |> Enum.each(fn blog ->
      param = %{assoc_id: blog.id}  # Default: penalty=beginning right now.

      evolve blog, param
    end)
  end

  defp evolve(blog, penalty) do
    Repo.transaction fn ->

      changeset =
        blog
        |> Repo.preload(:penalty)
        |> Blog.penalty_changeset(%{"penalty" => penalty})

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
