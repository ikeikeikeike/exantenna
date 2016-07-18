defmodule Exantenna.Locale.Plug.ConfigureGettext do

  def init(opts), do: opts

  def call(conn, _opts) do
    locale = conn.assigns[:locale]
    if locale in Gettext.known_locales(Exantenna.Gettext) do
      Gettext.put_locale(Exantenna.Gettext, locale)
      Gettext.put_locale(Phoenix.HTML.SimplifiedHelpers.Gettext, locale)
      conn
    else
      conn
    end
  end
end
