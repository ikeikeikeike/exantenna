defmodule Exantenna.Score.Inlog do

  alias Exantenna.Blank
  alias Exantenna.Redis

  @host  Application.get_env(:exantenna, :url)[:host]
  @uaptn ~r(Mozilla|Opera)
  @acceptptn ~r/.*(text|html,application|xhtml)/

  def resource(urls) when is_list(urls) do
    logs = Enum.filter(Redis.Inlog.all, &inlog?(&1))
    Redis.Inlog.clear

    Enum.reduce urls, %{}, fn url, t ->
      elems =
        Enum.filter logs, fn log ->
          String.contains?(log["referer"], url)
        end

      Map.put t, url, elems
    end
  end

  def scoring(resource) do

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
  # - Check the same ip after this.
  #
  def inlog?(%{
    "referer" => ref, "http_host" => host,
    "accept" => accept, "user-agent" => ua
  }) do

    accept =
      Enum.filter String.split(accept, "/"), fn text ->
        Regex.match?(@acceptptn, text)
      end

    cond do
      ! Regex.match?(@uaptn, ua) ->
        false
      Blank.blank?(ref) ->
        false
      String.contains?(ref, @host) ->
        false
      URI.parse(ref).host == host ->
        false
      length(accept) < 2 ->
        false
      true ->
        true
    end
  end
  def inlog?(_), do: false

end
