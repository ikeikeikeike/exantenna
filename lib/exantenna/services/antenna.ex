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
  alias Exantenna.Toon

  alias Exantenna.Translator

  def add_by(%Blog{}, nil), do: {:warn, "nil value"}
  def add_by(%Blog{}, %{"url" => url}) when is_nil(url), do: {:error, "Item's url was nil"}
  def add_by(%Blog{} = blog, item) do
    antenna =
      Antenna.where_url(Antenna.query_all, item["url"])
      |> Repo.one

    antenna =
      if antenna, do: antenna, else: %Antenna{
        blog: blog,      entry: %Entry{},     metadata: %Metadata{},
        video: %Video{}, picture: %Picture{}, summary: %Summary{},
        tags: [],        divas: [],           toons: []
      }

    insert_with_transaction(antenna, item)
  end

  def insert_with_transaction(%Antenna{id: nil} = antenna, %{
    "url"    => _, "title" => _, "explain" => _,
    "images" => _, "tags" => _, "pictures" => _, "videos" => _} = item
  ) do
    Repo.transaction fn ->
      try do
        antenna =
          Repo.insert!(antenna)
          |> Repo.preload(Antenna.full_relational_fields)

        item = additional_value(item)

        multi =
          Multi.new
          |> Multi.update(:entry, Entry.item_changeset(antenna, item))
          |> Multi.update(:metadata, Metadata.item_changeset(antenna, item))
          |> Multi.update(:video, Video.item_changeset(antenna, item))
          |> Multi.update(:picture, Picture.item_changeset(antenna, item))
          |> Multi.update(:summary, Summary.item_changeset(antenna, item))
          |> Multi.update(:tags, Tag.item_changeset(antenna, item))
          |> Multi.update(:divas, Diva.item_changeset(antenna, item))
          |> Multi.update(:toons, Toon.item_changeset(antenna, item))

        case Repo.transaction(multi) do
          {:ok, map} ->
            map = Map.merge(map, %{
              tags: map.tags.tags,
              divas: map.divas.divas,
              toons: map.toons.toons,
            })
            struct(antenna, map)

          {:error, failed_operation, failed_value, changes_so_far} ->
            msg = {failed_operation, failed_value, changes_so_far, item}
            Repo.rollback(msg)
        end
      rescue
        reason in Postgrex.Error ->
          Repo.rollback(reason)
      # after
        # nil
      end
    end
  end
  def insert_with_transaction(antenna, _item) do
    {:warn, "%Antenna{id: #{antenna.id}} record has been existed"}
  end

  defp additional_value(item) do
    Translator.configure

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
