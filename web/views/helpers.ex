defmodule Exantenna.Helpers do
  @moduledoc """
  Conveniences for translating and building error messages.
  """

  use Phoenix.HTML
  import Ecto.Query, only: [from: 1, from: 2]

  alias Exantenna.Repo

  alias Exantenna.Tag
  alias Exantenna.Toon
  alias Exantenna.Diva
  alias Exantenna.Char
  alias Exantenna.Video
  alias Exantenna.Picture
  alias Exantenna.Thumb
  alias Exantenna.Score
  alias Exantenna.Antenna

  alias Exantenna.Filter
  alias Exantenna.Ecto.Extractor

  @doc """
  Generates tag for inlined form input errors.
  """
  def error_tag(form, field) do
    if error = form.errors[field] do
      content_tag :span, translate_error(error), class: "help-block"
    end
  end

  @doc """
  Translates an error message using gettext.
  """
  def translate_error({msg, opts}) do
    # Because error messages were defined within Ecto, we must
    # call the Gettext module passing our Gettext backend. We
    # also use the "errors" domain as translations are placed
    # in the errors.po file. On your own code and templates,
    # this could be written simply as:
    #
    #     dngettext "errors", "1 file", "%{count} files", count
    #
    Gettext.dngettext(Exantenna.Gettext, "errors", msg, msg, opts[:count] || 0, opts)
  end
  def translate_error(msg) do
    Gettext.dgettext(Exantenna.Gettext, "errors", msg)
  end

  def translate_default({msg, opts}) do
    Gettext.dngettext(Exantenna.Gettext, "default", msg, msg, opts[:count] || 0, opts)
  end
  def translate_default(msg) do
    Gettext.dgettext(Exantenna.Gettext, "default", msg || "")
  end

  def locale do
    Gettext.get_locale(Exantenna.Gettext)
  end

  def take_params(%Plug.Conn{} = conn, keys)        when is_list(keys),                    do: take_params(conn, keys, %{})
  def take_params(%Plug.Conn{} = conn, keys, merge) when is_list(keys) and is_list(merge), do: take_params(conn, keys, Enum.into(merge, %{}))
  def take_params(%Plug.Conn{} = conn, keys, merge) do
    conn.params
    |> Map.take(keys)
    |> Map.merge(merge)
  end

  def nextnav_carried_params do
    ~w(q)
  end

  def search_carried_params do
    ~w(page q)
  end

  def search_value(conn) do
    [
      conn.params["q"],
      conn.params["tag"],
      conn.params["diva"],
      conn.params["toon"],
      conn.params["char"]
    ]
    |> Enum.uniq
    |> Enum.join(" ")
    |> String.trim
  end

  def to_keylist(params) do
    Enum.reduce(params, [], fn {k, v}, kw ->
      if !is_atom(k), do: k = String.to_atom(k)
      Keyword.put(kw, k , v)
    end)
  end

  def to_qstring(params) do
    "?" <> URI.encode_query params
  end

  def take_hidden_field_tags(%Plug.Conn{} = conn, keys) when is_list(keys) do
    Enum.map take_params(conn, keys), fn{key, value} ->
      Tag.tag(:input, type: "hidden", id: key, name: key, value: value)
    end
  end

  defdelegate blank?(word), to: Exantenna.Blank, as: :blank?
  defdelegate model_to_string(model), to: Extractor, as: :model_to_string

  def human_datetime(datetime) do
    Timex.format! datetime, "%F %R", :strftime
  end

  def to_age(date) do
    d = Timex.Date.today
    age = d.year - date.year
    if (date.month > d.month or (date.month >= d.month and date.day > d.day)), do: age = age - 1
    age
  end

  def pick(nil), do: nil
  def pick(%Thumb{} = thumb), do: thumb
  def pick(thumbs) when is_list(thumbs), do: List.first thumbs
  def pick(_), do: nil

  # TODO: make sure that thumb are desc or asc in better ordering.
  # def better(%Thumb{} = thumb), do: thumb
  # def better(thumbs) when is_list(thumbs), do: List.first thumbs

  def thumbs_all(%Toon{} = model) do
    thumbs =
      Extractor.defget(model.chars, [])
      |> Enum.flat_map(& &1.thumbs)
      |> Enum.uniq

    thumbs ++ Extractor.thumb(model)
    |> Enum.uniq
  end
  def thumbs_all(%Char{} = model) do
    thumbs =
      Extractor.defget(model.toons, [])
      |> Enum.flat_map(&thumbs_all &1)

    model.thumbs ++ thumbs
    |> Enum.uniq
  end
  def thumbs_all(model), do: Extractor.thumb model

  def choose_thumb(%Antenna{} = antenna, :entry) do
    choose_thumb(antenna)
  end
  def choose_thumb(%Antenna{} = antenna, :picture) do
    thumb = List.first antenna.picture.thumbs

    unless thumb, do: thumb = models_thumb(thumb, antenna.toons)
    unless thumb, do: thumb = models_thumb(thumb, antenna.toons, [:chars])
    unless thumb, do: thumb = choose_thumb(antenna)

    thumb
  end
  def choose_thumb(%Antenna{} = antenna, :toon) do
    thumb = models_thumb(nil, antenna.toons)

    unless thumb, do: thumb = models_thumb(thumb, antenna.toons, [:chars])
    unless thumb, do: thumb = List.first antenna.picture.thumbs
    unless thumb, do: thumb = choose_thumb(antenna)

    thumb
  end
  def choose_thumb(%Antenna{} = antenna, :diva) do
    thumb = models_thumb(nil, antenna.divas)

    unless thumb, do: thumb = List.first antenna.picture.thumbs
    unless thumb, do: thumb = models_thumb(thumb, antenna.toons)
    unless thumb, do: thumb = models_thumb(thumb, antenna.toons, [:chars])
    unless thumb, do: thumb = choose_thumb(antenna)

    thumb
  end
  def choose_thumb(%Antenna{} = antenna, :video) do
    thumb = List.first antenna.picture.thumbs

    unless thumb, do: thumb = models_thumb(thumb, antenna.divas)
    unless thumb, do: thumb = choose_thumb(antenna)

    thumb
  end
  def choose_thumb(%Antenna{} = antenna) do
    thumb = List.first antenna.entry.thumbs
    unless thumb, do: thumb = List.first antenna.picture.thumbs

    thumb =
      thumb
      |> models_thumb(antenna.toons)
      |> models_thumb(antenna.toons, [:chars])
      |> models_thumb(antenna.divas)
      |> models_thumb(antenna.video.metadatas)
      |> models_thumb(antenna.tags)
  end
  def choose_thumb(%Diva{} = diva) do
    thumb = pick(diva.thumbs)

    Enum.reduce diva.antennas, thumb, fn antenna, acc ->
      case acc do
        nil -> choose_thumb(antenna, :diva)
        acc -> acc
      end
    end
  end
  def choose_thumb(%Tag{} = tag) do
    thumb = pick(tag.thumbs)

    Enum.reduce tag.antennas, thumb, fn antenna, acc ->
      case acc do
        nil -> choose_thumb(antenna, :toon)
        acc -> acc
      end
    end
  end
  def choose_thumb(%Toon{} = toon) do
    thumb = pick(toon.thumbs)

    Enum.reduce toon.antennas, thumb, fn antenna, acc ->
      case acc do
        nil -> choose_thumb(antenna, :toon)
        acc -> acc
      end
    end
  end
  def choose_thumb(%Char{} = char) do
    thumb = pick(char.thumbs)

    Enum.reduce char.toons, thumb, fn toon, acc ->
      case acc do
        nil -> choose_thumb(toon)
        acc -> acc
      end
    end
  end
  def choose_thumb(%Antenna{} = antenna, :fallback) do
    nil
    |> models_thumb(antenna.toons, [:chars])
    |> models_thumb(antenna.divas)
    |> models_thumb(antenna.toons)
  end
  def choose_thumb(%Antenna{} = antenna, :backup) do
    choose_thumb(antenna, :picture)
  end
  def choose_thumb(%{antennas: _} = model, :fallback) do
    Enum.reduce Enum.reverse(model.antennas), nil, fn antenna, acc ->
      case acc do
        nil -> choose_thumb(antenna, :entry)
        acc -> acc
      end
    end
  end
  def choose_thumb(%{antennas: _} = model, :backup) do
    Enum.reduce model.antennas, nil, fn antenna, acc ->
      case acc do
        nil -> choose_thumb(antenna, :picture)
        acc -> acc
      end
    end
  end

  def models_thumb(%Thumb{} = thumb, _models), do: thumb
  def models_thumb(thumb, models) do
    unless thumb do
      if model = List.first models do
        thumb = List.first model.thumbs
      end
    end

    thumb
  end
  def models_thumb(thumb, _models, []), do: thumb
  def models_thumb(thumb, models, [h|tail]) do
    unless thumb do
      if model = List.first models do
        if blank?(tail) do
          thumb = List.first model.thumbs
        else
          thumb = models_thumb(thumb, Map.get(model, h), tail)
        end
      end
    end

    thumb
  end

  def ordering(models, :child, :available) do
    Enum.sort models, fn a, b ->
      blank?(pick(b.thumbs))
    end
  end

  def anstget(%Antenna{} = antenna), do: antenna
  def anstget(%{antenna: antenna}), do: anstget antenna

  def prev_blog(%Plug.Conn{} = conn, %Antenna{} = antenna) do
    Antenna.prev_blog(Antenna.query_all(:index), antenna)
    |> Exantenna.Domain.Q.allowed_join(conn)
    |> Repo.one
  end

  def next_blog(%Plug.Conn{} = conn, %Antenna{} = antenna) do
    Antenna.next_blog(Antenna.query_all(:index), antenna)
    |> Exantenna.Domain.Q.allowed_join(conn)
    |> Repo.one
  end

  def dynamical_path(method, args) do
    apply Exantenna.Router.Helpers, String.to_atom(method), args
  end

  def sitemeta(key), do: sitemeta(:default, key)
  def sitemeta(env, key) when is_bitstring(env), do: sitemeta String.to_atom(env), key
  def sitemeta(nil, key), do: Application.get_env(:exantenna, :sitemetas)[:default][key]
  def sitemeta(:book, key), do: Application.get_env(:exantenna, :sitemetas)[:book][key]
  def sitemeta(:video, key), do: Application.get_env(:exantenna, :sitemetas)[:video][key]
  def sitemeta(:default, key), do: Application.get_env(:exantenna, :sitemetas)[:default][key]
  def sitemeta(domain, key), do: Application.get_env(:exantenna, :sitemetas)[domain][key]

  def fallback, do: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsQAAA7EAZUrDhsAAAANSURBVBhXYzh8+PB/AAffA0nNPuCLAAAAAElFTkSuQmCC"

  def enc(:json, model, thumbs) when is_list(thumbs) do
    ConCache.get_or_store :encjson, "#{model_to_string model}:#{model.id}:#{length thumbs}", fn ->
      Poison.encode! thumbs
    end
  end
  def enc(:json, model) do
    enc :json, model, thumbs_all(model)
  end

  def random_icon_selector(name \\ "glyphicon") do
    icons =
      ConCache.get_or_store :common, "icon:#{name}", fn ->
        path =
          Application.get_env(:exantenna, Exantenna.Endpoint)[:root]
          |> Path.join("config/icons.yml")

        yml = :yamerl_constr.file path
        :proplists.get_value '#{name}', hd(yml)
      end

    Enum.random icons
  end

  def appeared(scores, nil, model), do: appeared scores, model
  def appeared(scores, subdomain, model), do: Score.appeared scores, subdomain, model_to_string(model)
  def appeared(scores, model), do: Score.appeared scores, model_to_string(model)

  def view_embed_on_safety(embed_code) do
    case String.contains?(embed_code, "iframe") do
      false -> raw embed_code
      true  -> PhoenixHtmlSanitizer.Helpers.sanitize embed_code, :full_html
    end
  end

  def get_title(%Antenna{} = antenna) do
    antenna.metadata.seo_title
  end

  def get_keywords(%Antenna{} = antenna) do
    antenna.tags ++ antenna.toons ++ antenna.divas
    |> Enum.map(fn(m) -> m.name end)
    |> Enum.join(",")
  end

  def get_description(%Antenna{} = antenna) do
    case blank?(antenna.metadata.seo_content) do
      false -> antenna.metadata.seo_content
      true  -> antenna.metadata.seo_title
    end
  end

end
