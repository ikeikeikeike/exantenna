defmodule Exantenna.Antenna do
  use Exantenna.Web, :model

  alias Exantenna.Es
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
    many_to_many :toons, Exantenna.Toon, join_through: "antennas_toons" # , on_delete: :delete_all, on_replace: :delete

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
          :thumbs,
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
      toons: [
        :thumb,
        chars: [
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

  def esindex(name \\ nil) do
    [type: Es.Index.name_type(__MODULE__), index: name || Es.Index.name_index(__MODULE__)]
  end

  def search_data(model) do
    meta = model.metadata
    tags = model.tags
    chars = model.chars
    toons = model.toons

    [
      _type: Es.name_type(__MODULE__),
      _id: model.id,
      title: meta.name,
      published_at: (case Timex.Ecto.DateTime.cast(meta.published_at) do
        {:ok, at} ->
          Timex.format!(at, "{ISO}")
        _ -> meta.published_at
      end),
      tags: [],
      toons: [],
      chars: [],
    ]
  end

  def esreindex, do: Es.Index.reindex __MODULE__, Repo.all(query_all)

  def create_esindex(name \\ nil) do
    Tirexs.DSL.define(fn ->
      use Tirexs.Mapping

      index = esindex(name)

      settings do
        analysis do
          filter    "ja_posfilter",     type: "kuromoji_neologd_part_of_speech", stoptags: ["助詞-格助詞-一般", "助詞-終助詞"]
          filter    "edge_ngram",       type: "edgeNGram", min_gram: 1, max_gram: 15

          tokenizer "ja_tokenizer",     type: "kuromoji_neologd_tokenizer"
          tokenizer "ngram_tokenizer",  type: "nGram",  min_gram: "2", max_gram: "3", token_chars: ["letter", "digit"]

          # analyzer  "default",          type: "custom", tokenizer: "ja_tokenizer", filter: ["kuromoji_neologd_baseform", "ja_posfilter", "cjk_width"]
          analyzer  "ja_analyzer",      type: "custom", tokenizer: "ja_tokenizer", filter: ["kuromoji_neologd_baseform", "ja_posfilter", "cjk_width"]
          analyzer  "ngram_analyzer",                   tokenizer: "ngram_tokenizer"
        end
      end

      mappings do
        indexes "title",          type: "string", analyzer: "ja_analyzer"
        indexes "published_at",   type: "date",   format: "dateOptionalTime"
        # indexes "video_title",    type: "string", analyzer: "ja_analyzer"
        # indexes "video_duration", type: "long"
        # indexes "sites",          type: "string", index: "not_analyzed"
        indexes "tags",           type: "string", index: "not_analyzed"
        indexes "toons",          type: "string", index: "not_analyzed"
        indexes "chars",          type: "string", index: "not_analyzed"
      end

      Es.ppdebug(index)

    index end)
  end

end
