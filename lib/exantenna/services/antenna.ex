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

  alias Exantenna.Translator
  alias Exantenna.Redises.Item

  def add_by(%Blog{} = blog) do
    Translator.configure

    item = Item.shift(blog.rss)
    item = Map.merge(item || %{}, %{
      # "seo_tags" => Enum.map(item["tags"], &Translator.tag(Translator.translate(&1))),
      "seo_title" => Translator.sentence(Translator.translate(item["title"])),
      "seo_content" => Translator.sentence(Translator.translate(item["explain"])),
    })

    antenna = %Antenna{
      blog: blog, entry: %Entry{}, metadata: %Metadata{},
      video: %Video{}, picture: %Picture{}, summary: %Summary{}, tags: [],
    }

    case insert_with_transaction(antenna, item) do
      {:ok, %{entry: entry, metadata: metadata, video: video, picture: picture, summary: summary , withtags: withtags}} ->
        antenna = struct(antenna, [
          entry: entry, metadata: metadata, video: video, picture: picture, summary: summary , tags: withtags.tags
        ])

        {:ok, antenna}

      {:error, failed_operation, failed_value, changes_so_far} ->
        msg = {failed_operation, failed_value, changes_so_far}
        {:error, msg}

      {:warn, msg} ->
        {:warn, msg}
    end
  end

  def insert_with_transaction(_antenna, %{}), do: {:warn, "blank value"}
  def insert_with_transaction(_antenna, nil), do: {:warn, "blank value"}
  def insert_with_transaction(antenna, item) do
    multi =
      Multi.new
      |> Multi.insert(:entry, Entry.item_changeset(antenna, item))
      |> Multi.insert(:metadata, Metadata.item_changeset(antenna, item))
      |> Multi.insert(:video, Video.item_changeset(antenna, item))
      |> Multi.insert(:picture, Picture.item_changeset(antenna, item))
      |> Multi.insert(:summary, Summary.item_changeset(antenna, item))
      |> Multi.insert(:withtags, Tag.item_changeset(antenna, item))
      # |> Multi.delete_all(:sessions, assoc(account, :sessions))

    Repo.transaction(multi)
  end

end
