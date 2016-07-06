defmodule Exantenna.Antenna do
  use Exantenna.Web, :model

  schema "antennas" do
    belongs_to :blog, Exantenna.Blog
    belongs_to :entry, Exantenna.Entry
    belongs_to :metadata, Exantenna.Metadata
    belongs_to :video, Exantenna.Video
    belongs_to :picture, Exantenna.Picture
    belongs_to :summary, Exantenna.Summary

    has_one :penalty, {"antennas_penalties", Exantenna.Penalty}, foreign_key: :assoc_id
    many_to_many :tags, Exantenna.Tag, join_through: "antennas_tags" # , on_delete: :delete_all, on_replace: :delete

    timestamps
  end

  @required_fields ~w()
  @optional_fields ~w()
  @relational_fields ~w(blog entry metadata video picture summary penalty tags)a

  def query do
    from e in __MODULE__,
     select: e,
    preload: ^@relational_fields
  end

  def query_full do
    from e in __MODULE__,
    preload: [
      :metadata,
      :penalty,
      blog: [:thumb, :penalty, :scores, :verifiers],
      entry: [:thumbs, :scores],
      video: :metadatas,
      picture: :thumbs,
      summary: :scores,
      tags: :thumb,
    ]
  end

  def query_pictures, do: query_full
  def query_entries, do: query_full
  def query_videos, do: query_full

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
