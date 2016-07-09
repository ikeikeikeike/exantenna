defmodule Exantenna.Antenna do
  use Exantenna.Web, :model
  alias Exantenna.Metadata

  schema "antennas" do
    belongs_to :blog, Exantenna.Blog
    belongs_to :entry, Exantenna.Entry
    belongs_to :metadata, Exantenna.Metadata
    belongs_to :video, Exantenna.Video
    belongs_to :picture, Exantenna.Picture
    belongs_to :summary, Exantenna.Summary

    has_one :penalty, {"antennas_penalties", Exantenna.Penalty}, foreign_key: :assoc_id
    has_many :scores, {"antennas_scores", Exantenna.Score}, foreign_key: :assoc_id

    many_to_many :tags, Exantenna.Tag, join_through: "antennas_tags" # , on_delete: :delete_all, on_replace: :delete
    many_to_many :divas, Exantenna.Diva, join_through: "antennas_divas" # , on_delete: :delete_all, on_replace: :delete
    many_to_many :animes, Exantenna.Anime, join_through: "antennas_animes" # , on_delete: :delete_all, on_replace: :delete

    timestamps
  end

  @required_fields ~w()
  @optional_fields ~w()
  @relational_fields ~w(blog entry metadata video picture summary penalty tags)a
  @full_relational_fields [
      :metadata,
      :scores,  # node in,out score
      :penalty,
      :summary,
      blog: [
        :thumb,
        :penalty,
        :scores,  # domain score + in,out score
        :verifiers
      ],
      entry: [
        :thumbs
      ],
      video: [
        metadatas: [
          :thumb,
          site: [:thumb],
        ],
      ],
      picture: [
        :thumbs
      ],
      tags: [
        :thumb
      ],
      divas: [
        :thumb
      ],
      animes: [
        :thumb,
        characters: [
          :thumb
        ],
      ],
    ]
  def full_relational_fields, do: @full_relational_fields

  def query do
    from e in __MODULE__,
    preload: ^@relational_fields
  end

  def query_all do
    from e in __MODULE__,
    preload: ^@full_relational_fields
  end

  def query_pictures, do: query_all
  def query_entries, do: query_all
  def query_videos, do: query_all

  def where_url(query, url) do
    from q in query,
      join: m in Metadata,
        on: m.id == q.metadata_id,
      where: m.url == ^url
  end

end
