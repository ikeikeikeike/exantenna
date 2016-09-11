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
alias Exantenna.Blank

Exantenna.Antenna.query_all
|> Exantenna.Repo.stream(chunk_size: 10000)
|> Stream.each(fn o ->
  if o.video do
    codes = Enum.filter o.video.metadatas, & !Blank.blank?(&1.embed_code)

    case length(codes) do
      x when x > 0 ->
        o.video
        |> Exantenna.Video.changeset(%{elements: x})
        |> Exantenna.Repo.update!
      _ ->
        o.video
        |> Exantenna.Video.changeset(%{elements: 0})
        |> Exantenna.Repo.update!
    end
  end

  if o.picture do
    case length(o.picture.thumbs) do
      x when x > 0 ->
        o.picture
        |> Exantenna.Picture.changeset(%{elements: x})
        |> Exantenna.Repo.update!
      _ -> nil
    end
  end
end)
|> Stream.run
