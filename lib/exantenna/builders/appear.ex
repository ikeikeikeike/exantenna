defmodule Exantenna.Builders.Appear do

  alias Exantenna.Repo
  alias Exantenna.Score
  alias Exantenna.Ecto.Extractor
  require Logger

  def aggs(mod) do
    modname = Extractor.toname mod

    aggs = Exantenna.Antenna.esaggs "#{modname}s"

    aggs.aggregations.values.buckets
    |> Enum.each(fn(term) ->
      Repo.transaction fn ->

        if model = Repo.get_by(mod, name: term.key) do
          params = %{
            "scores" => [%{
              "assoc_id" => model.id,
              "name" => "#{modname}_appeared",
              "count" => term.doc_count
            }]
          }

          changeset =
            model
            |> Repo.preload(:scores)
            |> mod.aggs_changeset(params)

          case Repo.insert_or_update(changeset) do
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
