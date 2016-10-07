# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Exantenna.Repo.insert!(%Exantenna.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Exantenna.Repo
alias Exantenna.Filter

alias Exantenna.Site
alias Exantenna.Antenna
alias Exantenna.VideoMetadata

Antenna.query_all
|> Repo.stream(chunk_size: 10000)
|> Stream.each(fn o ->

  if Filter.allow?(:video, o) do
    Enum.each o.video.metadatas, fn meta ->
      site = Site.get_or_changeset(Site, %{url: meta.url})

      VideoMetadata.changeset(%{site: site})
      |> Repo.update!
    end
  end
end)
|> Stream.run
