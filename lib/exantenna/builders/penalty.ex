defmodule Exantenna.Builders.Penalty do
  alias Exantenna.Repo
  alias Exantenna.Blog
  alias Exantenna.Score
  alias Exantenna.Antenna
  alias Exantenna.Penalty

  import Ecto.Query, only: [from: 1, from: 2]
  require Logger

  # TODO: must make below particularly :begin status.

  def penalty(:up) do

  end

  def penalty(:down) do

  end

  def penalty(:left) do

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
      model =
        case blog.penalty do
          nil     ->
            %{assoc_id: blog.id}  # Default: penalty=beginning right now.

          model ->
            honeymoon =
              Timex.shift model.inserted_at, days: 20

            case Timex.compare(honeymoon, dt) do
              1  ->
                Map.from_struct model
              0  ->
                Map.from_struct model
              -1 ->
                Map.from_struct struct(model, [penalty: Penalty.const_none])
            end
        end

      evolve blog, model
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
      model = %{assoc_id: blog.id}  # Default: penalty=beginning right now.

      evolve blog, model
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
