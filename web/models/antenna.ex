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
    many_to_many :toons, Exantenna.Toon, join_through: "antennas_toons" # , on_delete: :delete_all, on_replace: :delete

    timestamps
  end

  @required_fields ~w()
  @optional_fields ~w()
  @relational_fields ~w(blog entry metadata video picture summary penalty tags)a
  @esreindex_fields [
      :metadata,
      :summary,
      :divas,
      :tags,
      entry: [
        :thumbs
      ],
      picture: [
        :thumbs
      ],
      video: [
        metadatas: [
          :site
        ],
      ],
      toons: [:chars]
    ]

  @show_relational_fields [
      :metadata,
      :scores,  # node in,out score
      :penalty,
      :summary,
      blog: [
        :thumbs,
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
          site: [:thumbs],
        ],
      ],
      picture: [
        :thumbs
      ],
      tags: [
        :scores,
        :thumbs
      ],
      divas: [
        :scores,
        :thumbs
      ],
      toons: [
        :scores,
        :thumbs,
        chars: [
          :scores,
          :thumbs
        ],
      ],
    ]

  @full_relational_fields [
      :metadata,
      :scores,  # node in,out score
      :penalty,
      :summary,
      blog: [
        :thumbs,
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
          site: [:thumbs],
        ],
      ],
      picture: [
        :thumbs
      ],
      tags: [
        :thumbs
      ],
      divas: [
        :thumbs
      ],
      toons: [
        :thumbs,
        chars: [
          :thumbs
        ],
      ],
    ]
  def full_relational_fields, do: @full_relational_fields

  def query do
    from e in __MODULE__,
    preload: ^@relational_fields
  end

  def query_all(:show) do
    from e in __MODULE__,
    preload: ^@show_relational_fields
  end

  def query_all do
    from e in __MODULE__,
    preload: ^@full_relational_fields
  end

  def query_pictures, do: query_all
  def query_entries, do: query_all
  def query_videos, do: query_all

  def prev_blogs(query, model) do
    from q in query,
      where: q.id < ^model.id
         and q.blog_id == ^model.blog_id
  end

  def next_blogs(query, model) do
    from q in query,
      where: q.id > ^model.id
         and q.blog_id == ^model.blog_id
  end

  def prev_blog(query, model) do
    from q in prev_blogs(query, model),
      order_by: [desc: q.id],
      limit: 1
  end

  def next_blog(query, model) do
    from q in next_blogs(query, model),
      order_by: [asc: q.id],
      limit: 1
  end

  def where_url(query, url) do
    from q in query,
      join: m in Metadata,
        on: m.id == q.metadata_id,
      where: m.url == ^url
  end

  use Exantenna.Es

  def essearch(nil), do: essearch(nil, [])
  def essearch(word), do: essearch(word, [])
  def essearch("", options), do: essearch(nil, options)
  def essearch(word, options) do
    result =
      Tirexs.DSL.define fn ->
        import Tirexs.Search
        import Tirexs.Query
        require Tirexs.Query.Filter

        opt = Es.Params.pager_option(options)

        # pagination
        # page = opt[:page]
        offset = opt[:offset]
        per_page = opt[:per_page]

        # How can I change query of part when word is not nil, like this.
        #
        #   ```elixir
        #   if word, do: multi_match([word, search_fields]), else: match_all([])
        #   ```
        #
        # Still it doesn't seem like changing from previous version.
        #

        q =
          search [index: esindex, fields: [], from: offset, size: per_page] do

            query do
              filtered do
                query do
                  match_all([])
                end
                filter do
                  bool do
                    must do
                      terms "is_summary", [true, false]
                      terms "is_video", [true, false]
                      terms "is_book", [true, false]
                    end
                  end
                end
              end
            end

            aggs do
              tags do
                terms field: "tags",  size: 20, order: [_count: "desc"]
              end
              toons do
                terms field: "toons", size: 20, order: [_count: "desc"]
              end
              chars do
                terms field: "chars", size: 20, order: [_count: "desc"]
              end
            end

            sort do
              [published_at: [order: "desc"]]
            end

          end

        # https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-multi-match-query.html
        if word do
          s = Tirexs.Query.multi_match [word, ~w(title tags toons chars)]
          q = put_in q, [:search, :query, :filtered, :query], s
        end

        if f = opt[:filter] do
          q = put_in q, [:search, :query, :filtered, :filter], Es.Filter.is_(f)
        end

        Es.Logger.ppdebug(q)

        q
      end

    case result do
      {_, _, map} -> map
      r -> r
    end
  end

  def esaggs(field), do: esaggs field, nil
  def esaggs(field, opts) when is_list(opts), do: esaggs field, Enum.into(opts, %{})
  def esaggs(field, opts) do
    {is_book, is_video} =
      case opts do
        %{book: true, video: true}  ->
          {[true], [true]}
        %{book: true}  ->
          {[true], [true, false]}
        %{video: true} ->
          {[true, false], [true]}
        _              ->
          {[true, false], [true, false]}
      end

    result =
      Tirexs.DSL.define fn ->
        import Tirexs.Search
        import Tirexs.Query

        q =
          search [index: esindex, fields: [], from: 0, size: 0] do
            query do
              filtered do
                filter do
                  bool do
                    must do
                      terms "is_book", is_book
                      terms "is_video", is_video
                    end
                  end
                end
              end
            end
            aggs do
              values do
                terms field: field, size: 50000, order: [_count: "desc"]
              end
            end
          end
        Es.Logger.ppdebug(q)
        q
      end

    case result do
      {_, _, map} -> map
      r -> r
    end
  end

  def search_data(%{metadata: nil}), do: nil
  def search_data(model) do
    meta = model.metadata

    published_at =
      case Timex.Ecto.DateTime.cast(meta.published_at || meta.inserted_at) do
        {:ok, at} -> Timex.format!(at, "{ISO}")
        :error    -> nil
        date      -> date
      end

    # IO.inspect "#{inspect published_at}: #{inspect meta.inserted_at}-#{inspect meta.published_at}"

    chars =
      Enum.flat_map model.toons, fn toon ->
        Enum.map toon.chars, &(&1.name)
      end

    [
      id: model.id,
      title: meta.title,
      published_at: published_at,
      tags: Enum.map(model.tags, &(&1.name)),
      divas: Enum.map(model.divas, &(&1.name)),
      toons: Enum.map(model.toons, &(&1.name)),
      chars: chars,
      is_summary: Exantenna.Filter.allow?(:summary, model),
      is_video: Exantenna.Filter.allow?(:video, model),
      is_book: Exantenna.Filter.allow?(:book, model),
    ]
  end

  def esreindex do
    q = from e in __MODULE__, preload: ^@esreindex_fields
    Es.Index.reindex __MODULE__, Repo.stream(q, chunk_size: 10000)
  end

  def create_esindex(name \\ nil) do
    Tirexs.DSL.define(fn ->
      use Tirexs.Mapping

      index = [type: estype, index: esindex(name)]

      settings do
        analysis do
          filter "ja_posfilter",
            type: "kuromoji_neologd_part_of_speech",
            stoptags: ["助詞-格助詞-一般", "助詞-終助詞"]
          filter "edge_ngram",
            type: "edgeNGram", min_gram: 1, max_gram: 15

          tokenizer "ja_tokenizer",
            type: "kuromoji_neologd_tokenizer"
          tokenizer "ngram_tokenizer",
            type: "nGram", min_gram: "2", max_gram: "3",
            token_chars: ["letter", "digit"]

          analyzer "default",
            type: "custom", tokenizer: "ja_tokenizer",
            filter: ["kuromoji_neologd_baseform", "ja_posfilter", "cjk_width"]
          analyzer "ja_analyzer",
            type: "custom", tokenizer: "ja_tokenizer",
            filter: ["kuromoji_neologd_baseform", "ja_posfilter", "cjk_width"]
          analyzer "ngram_analyzer",
            tokenizer: "ngram_tokenizer"
        end
      end

      Es.Logger.ppdebug(index)

    index end)

    Tirexs.DSL.define(fn ->
      use Tirexs.Mapping

      index = [type: estype, index: esindex(name)]

      mappings do
        indexes "title", type: "string", analyzer: "ja_analyzer"
        indexes "published_at", type: "date", format: "dateOptionalTime"
        # indexes "video_title",    type: "string", analyzer: "ja_analyzer"
        # indexes "video_duration", type: "long"
        # indexes "sites",          type: "string", index: "not_analyzed"
        indexes "tags",  type: "string", index: "not_analyzed"
        indexes "divas", type: "string", index: "not_analyzed"
        indexes "toons", type: "string", index: "not_analyzed"
        indexes "chars", type: "string", index: "not_analyzed"

        indexes "is_summary", type: "boolean"
        indexes "is_video", type: "boolean"
        indexes "is_book", type: "boolean"
      end

      Es.Logger.ppdebug(index)

    index end)
  end

end
