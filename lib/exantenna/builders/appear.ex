defmodule Exantenna.Builders.Appear do

  alias Exantenna.Repo
  alias Exantenna.Score
  alias Exantenna.Ecto.Extractor
  require Logger

  def aggs(mod) do
    modname = Extractor.toname mod

    name = Score.name_appeared(modname)
    merged =
      Enum.reduce Exantenna.Antenna.esaggs("#{modname}s").aggregations.values.buckets, %{}, fn map, acc ->
        m = %{name => map}
        Map.update(acc, map[:key], m, &Map.merge(&1, m))
      end

    name = Score.name_appeared("video", modname)
    merged =
      Enum.reduce Exantenna.Antenna.esaggs("#{modname}s", video: true).aggregations.values.buckets, merged, fn map, acc ->
        m = %{name => map}
        Map.update(acc, map[:key], m, &Map.merge(&1, m))
      end

    name = Score.name_appeared("book", modname)
    merged =
      Enum.reduce Exantenna.Antenna.esaggs("#{modname}s", book: true).aggregations.values.buckets, merged, fn map, acc ->
        m = %{name => map}
        Map.update(acc, map[:key], m, &Map.merge(&1, m))
      end

    ExSentry.capture_exceptions fn ->
      aggs mod, merged
    end
  end

  def aggs(mod, aggs) do
    modname = Extractor.toname mod

    aggs
    |> Enum.each(fn {key, terms} ->
      Repo.transaction fn ->

        if model = Repo.get_by(mod, name: key) do

          name = Score.name_appeared(modname)
          scores =
            case terms[name] do
              nil -> []
              map ->
                [%{
                  "assoc_id" => model.id,
                  "name" => name,
                  "count" => map.doc_count
                }]
            end

          name = Score.name_appeared("video", modname)
          scores = scores ++
            case terms[name] do
              nil -> []
              map ->
                [%{
                  "assoc_id" => model.id,
                  "name" => name,
                  "count" => map.doc_count
                }]
              false -> []
            end

          name = Score.name_appeared("book", modname)
          scores = scores ++
            case terms[name] do
              nil -> []
              map ->
                [%{
                  "assoc_id" => model.id,
                  "name" => name,
                  "count" => map.doc_count
                }]
            end

          changeset =
            model
            |> Repo.preload(:scores)
            |> mod.score_changeset(%{"scores" => scores})

          case Repo.update(changeset) do
            {:error, reason} ->
              Repo.rollback(reason)
            {_, model} ->
              model
          end
        end
      end
    end)

  end
end
