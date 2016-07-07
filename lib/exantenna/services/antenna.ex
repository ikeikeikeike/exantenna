defmodule Exantenna.Services.Antenna do
  alias Ecto.Multi

  alias Exantenna.Repo

  alias Exantenna.Blog
  alias Exantenna.Antenna

  alias Exantenna.Entry
  alias Exantenna.Metadata
  alias Exantenna.Video
  alias Exantenna.Picture
  alias Exantenna.Summary
  alias Exantenna.Tag
  alias Exantenna.Diva
  alias Exantenna.Anime

  alias Exantenna.Translator
  alias Exantenna.Redises.Item

  defp setup do
    Translator.configure
  end

  def add_by(%Blog{} = blog) do
    setup

    item = additional_value(Item.shift(blog.rss))

    antenna = %Antenna{
      blog: blog, entry: %Entry{}, metadata: %Metadata{},
      video: %Video{}, picture: %Picture{}, summary: %Summary{},
      tags: [], divas: [], animes: []
    }

    case insert_with_transaction(antenna, item) do
      {:ok, map} ->
        map = Map.merge(map, %{
          tags: map["tags"].tags,
          divas: map["divas"].divas,
          animes: map["animes"].animes,
        })

        {:ok, struct(antenna, map)}

      {:error, failed_operation, failed_value, changes_so_far} ->
        msg = {failed_operation, failed_value, changes_so_far}
        {:error, msg}

      {:warn, msg} ->
        {:warn, msg}
    end
  end

  def insert_with_transaction(antenna, %{
    "url" => _, "title" => _, "explain" => _,
    "images" => _, "tags" => _, "pictures" => _, "videos" => _} = item
  ) do
    multi =
      Multi.new
      |> Multi.insert(:entry, Entry.item_changeset(antenna, item))
      |> Multi.insert(:metadata, Metadata.item_changeset(antenna, item))
      |> Multi.insert(:video, Video.item_changeset(antenna, item))
      |> Multi.insert(:picture, Picture.item_changeset(antenna, item))
      |> Multi.insert(:summary, Summary.item_changeset(antenna, item))
      |> Multi.insert(:tags, Tag.item_changeset(antenna, item))
      |> Multi.insert(:divas, Diva.item_changeset(antenna, item))
      |> Multi.insert(:animes, Anime.item_changeset(antenna, item))
      # |> Multi.delete_all(:sessions, assoc(account, :sessions))

    Repo.transaction(multi)
  end
  def insert_with_transaction(_antenna, _), do: {:warn, "blank value"}

  defp additional_value(item) do
    title = HtmlSanitizeEx.strip_tags(item["title"])
    explain = HtmlSanitizeEx.strip_tags(item["explain"])

    Map.merge(item || %{}, %{
      # "seo_tags" => Enum.map(item["tags"], &Translator.tag(Translator.translate(&1))),
      "title" => title,
      "explain" => explain,
      "seo_title" => Translator.sentence(Translator.translate(title)),
      "seo_explain" => Translator.sentence(Translator.translate(explain)),
    })
  end

end
