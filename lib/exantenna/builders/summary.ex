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

  @limit 1500

  # TODO: below
  # Find entry 10 days ago and not pushed entry yet.

  # The following is terminated ::

  	# - Add thirty record to summary
  	# - If stored 30 entities already, no register.
  	# - 10,000 Loop.
  	# - 10 days ago.

  # launch "45 * * * *"
  def aggs do
    ExSentry.capture_exceptions fn ->

      blogs = Exantenna.Builders.Score.inscore_into

      resource =
        blogs
        |> Enum.filter(fn b ->
          ! b.id in [135] # Ignore 135 id
        end)
        |> Enum.flat_map(fn b ->
          Enum.filter b.scores, & &1.name == Score.const_in_weekly
          # Enum.filter b.scores, & &1.name == Score.const_in_daily
        end)
        |> Enum.reduce(%{}, fn b, acc ->
          Map.merge acc, %{b.assoc_id => b.count}
        end)
        |> WalkersAliasMethod.resource  # TODO: Fix right of expression: WalkersAliasMethod.resource %{1 => 0, 2 => 0}

      ids =
        Enum.map(1..@limit, fn _ ->
          WalkersAliasMethod.choice(resource)
        end)
        |> Enum.filter(& &1)
        # |> Enum.uniq

      # TODO: must fix logic below to better with selected ids.
      qs =
        from a in Antenna.query_all(:esreindex),
          where: a.blog_id in ^ids,
          order_by: [desc: a.id],
          limit: ^@limit

      updateable =
        qs
        |> Repo.all
        |> Enum.shuffle
        |> Enum.with_index
        |> Enum.map(fn {an, index} ->
          m = Antenna.summary_changeset an, %{summary: %{sort: index}}
          Repo.update! m
        end)

      if length(updateable) > div(@limit, 2) do
        qs =
          from a in Antenna.query_all(:esreindex),
            join: s in Summary,
            where: s.id == a.summary_id,
            order_by: [asc: a.id],
            limit: ^div(@limit, 2)

        removeable =
          qs
          |> Repo.all
          |> Enum.map(fn an ->
            m = Summary.changeset an.summary, %{}
            Repo.delete! m

            struct an, [summary: nil, summary_id: nil]
          end)

        Es.Document.put_document(removeable)
      end

      Es.Document.put_document(updateable)

    end
  end

end
