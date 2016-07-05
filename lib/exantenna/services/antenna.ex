defmodule Exantenna.Services.Antenna do
  alias Ecto.Multi

  alias Exantenna.Repo

  alias Exantenna.Blog
  alias Exantenna.Antenna

  alias Exantenna.Metadata
  alias Exantenna.Entry
  alias Exantenna.Video
  alias Exantenna.Picture
  alias Exantenna.Summary
  alias Exantenna.Tag

  alias Exantenna.Redises.Item

  require Logger

  def add_by(%Blog{} = blog) do

    item = Item.shift blog.rss
    # TODO: seo title, seo content, etc..

    antenna = %Antenna{
      blog: blog,
      entry: %Entry{},
      metadata: %Metadata{},
      video: %Video{},
      picture: %Picture{},
      summary: %Summary{},
      tags: [],
    }

    case Repo.transaction(insert(antenna, item)) do
      {:ok, %{entry: entry, metadata: metadata, video: video, picture: picture, summary: summary, tags: tags}} ->
        nil

      {:error, failed_operation, failed_value, changes_so_far} ->
        msg = "#{inspect failed_operation} #{inspect failed_value} #{inspect changes_so_far}"
        Repo.rollback(msg)
        Logger.error(msg)
    end
  end

  def insert(antenna, item) do
    require IEx; IEx.pry

    Multi.new
    |> Multi.insert(:entry, Entry.item_changeset(antenna, item))
    |> Multi.insert(:metadata, Metadata.item_changeset(antenna, item))
    |> Multi.insert(:video, Video.item_changeset(antenna, item))
    |> Multi.insert(:picture, Picture.item_changeset(antenna, item))
    |> Multi.insert(:summary, Summary.item_changeset(antenna, item))
    |> Multi.insert(:tags, Tag.item_changeset(antenna, item))
    # |> Multi.delete_all(:sessions, assoc(account, :sessions))
  end

end
