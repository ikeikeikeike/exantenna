defmodule Exantenna.Builders.Summary do

  alias Exantenna.Es
  alias Exantenna.Summary
  alias Exantenna.Antenna
  alias Exantenna.Repo
  alias Exantenna.Blog
  alias Exantenna.Blank
  alias Exantenna.Score
  alias Exantenna.Score.Inlog
  alias Wakaway.WalkersAliasMethod

  import Ecto.Query, only: [from: 1, from: 2]

  require Logger

  # Find entry 10 days ago and not pushed entry yet.

  # The following is terminated ::

  	# - Add thirty record to summary
  	# - If stored 30 entities already, no register.
  	# - 10,000 Loop.
  	# - 10 days ago.

  # launch "45 * * * *"
  def aggs do
    blogs = Exantenna.Builders.Score.inscore_into

    resource =
      Enum.flat_map(blogs, fn b ->
        Enum.filter b.scores, & &1.name == Score.const_in_daily
      end)
      |> Enum.reduce(%{}, fn b, acc ->
        Map.merge acc, %{b.assoc_id => b.count}
      end)
      |> WalkersAliasMethod.resource

    ids =
      Enum.map 1..500, fn _ ->
        WalkersAliasMethod.choice(resource)
      end

    qs =
      from a in Antenna.query_all(:esreindex),
        join: s in Summary,
        where: s.id == a.summary_id,
        order_by: [asc: a.inserted_at],
        limit: 500

    removeable =
      qs
      |> Repo.all
      |> Enum.map(fn an ->
        m = Summary.changeset an.summary, %{}
        Repo.delete! m

        struct an, [summary: nil, summary_id: nil]
      end)

    Es.Document.delete_document(removeable)

    qs =
      from a in Antenna.query_all(:esreindex),
        join: b in Blog,
        where: b.id in ^ids,
        order_by: [desc: a.inserted_at],
        limit: 500

    insertable =
      qs
      |> Repo.all
      |> Enum.shuffle
      |> Enum.with_index
      |> Enum.map(fn {an, index} ->
        m = Antenna.summary_changeset an, %{summary: %{sort: index}}
        Repo.update! m
      end)

    Es.Document.put_document(insertable)
  end

end
