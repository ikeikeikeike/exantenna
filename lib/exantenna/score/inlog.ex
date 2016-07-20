defmodule Exantenna.Score.Inlog do

  alias Exantenna.Blank
  alias Exantenna.Redis

  @host  Application.get_env(:exantenna, :url)[:host]
  @uaptn ~r(Mozilla|Opera)

  def scoring(urls) when is_list(urls) do
    logs =
      Redis.Inlog.all
      |> Enum.filter(&inlog?(&1))

    Redis.Inlog.clear

    Enum.map urls, fn url ->
      # URI.parse(url).host

      # TODO: extract search key from url
      key = ""

      Enum.filter logs, fn log ->
        String.contains?(log["referer"], key)
      end

    end

    # Enum.filter
  end

  # Doing no aggregation excepting below.
  # Should make sure below for adding to scores.
  #
  # - Correct User-Agent format.
  # - Has Referer
  # - Own site Referer(using define constants in config.ex)
  # - Own site Referer(the same domain betweeen Referer and Request URL)
  # - js, css, img.src request, only html request
  #
  def inlog?(%{"url" => url, "user-agent" => ua, "referer" => ref}) do
    cond do
      ! Regex.match?(@uaptn, ua) ->
        false
      Blank.blank?(ref) ->
        false
      String.contains?(ref, @host) ->
        false
      URI.parse(ref).host == URI.parse(url).host ->
        false

      # TODO: only html request

      true ->
        true
    end
  end

end
