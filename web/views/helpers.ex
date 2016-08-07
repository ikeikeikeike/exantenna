defmodule Exantenna.Helpers do
  @moduledoc """
  Conveniences for translating and building error messages.
  """

  use Phoenix.HTML

  alias Exantenna.Repo
  alias Exantenna.Thumb
  alias Exantenna.Antenna

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

  def thumbs_all(%Antenna{} = antenna), do: Exantenna.Ecto.Extractor.thumb antenna

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

  def prev_blog(%Antenna{} = antenna) do
    Repo.one Antenna.prev_blog(Antenna.query_all, antenna)
  end

  def next_blog(%Antenna{} = antenna) do
    Repo.one Antenna.next_blog(Antenna.query_all, antenna)
  end

  def dynamical_path(method, args) do
    apply Exantenna.Router.Helpers, String.to_atom(method), args
  end

  def sitemeta(key), do: sitemeta(:default, key)
  def sitemeta(:default, key), do: Application.get_env(:exantenna, :sitemetas)[:default][key]
  def sitemeta(:video, key), do: Application.get_env(:exantenna, :sitemetas)[:video][key]
  def sitemeta(:book, key), do: Application.get_env(:exantenna, :sitemetas)[:book][key]
  def sitemeta(domain, key), do: Application.get_env(:exantenna, :sitemetas)[domain][key]

  def fallback, do: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsQAAA7EAZUrDhsAAAANSURBVBhXYzh8+PB/AAffA0nNPuCLAAAAAElFTkSuQmCC"

end
