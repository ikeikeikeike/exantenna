defmodule Exantenna.Score.Inlog do

  alias Exantenna.Blank
  alias Exantenna.Redis

  @host  Application.get_env(:exantenna, :url)[:host]
  @uaptn ~r(Mozilla|Opera)
  @acceptptn ~r/.*(text|html,application|xhtml)/

  def resource(urls) when is_list(urls) do
    logs = Enum.filter(Redis.Inlog.all, &inlog?(&1))
    Redis.Inlog.clear

    Enum.reduce urls, %{}, fn url, acc ->
      r =
        Enum.filter logs, fn log ->
          String.contains?(log["referer"], url)
        end

      Map.put acc, url, r
    end
  end

  def scoring(resource) do

  end

  """
  after check ip address

  Accept:image/webp,image/*,*/*;q=0.8
  Accept-Encoding:gzip, deflate, sdch, br
  Accept-Language:en-US,en;q=0.8,ja;q=0.6
  Connection:keep-alive
  Cookie:__cfduid=dc81e3e22305566f0b55d04c26c234354tr; azk-sync=22.1%3A1469075679; azk=ue1-e020624cf0834e16a96c0219d78ebb95
  Host:engine.adzerk.net
  Referer:https://lksdajflk.com/dlkajfl=183712&cb=https%3A%2F%ldkajfld.net%2Fudb%2F22%2Fsync%2Fi.gif%3FpartnerId%3D1%26userId%3D
  User-Agent:Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36
  Query String Parameters
  """

  """
  after check ip address

  Accept:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
  Accept-Encoding:gzip, deflate, sdch
  Accept-Language:en-US,en;q=0.8,ja;q=0.6
  Connection:keep-alive
  Cookie:__cfduid=dc81e3e22305566f0b55d04c26c234354tr; azk-sync=22.1%3A1469075679; azk=ue1-e020624cf0834e16a96c0219d78ebb95
  Host:cafe.diaufj.com
  Referer:http://dlakfj.com/ldkjsaf/10339049
  Upgrade-Insecure-Requests:1
  User-Agent:Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36
  """



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
