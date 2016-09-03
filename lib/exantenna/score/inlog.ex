defmodule Exantenna.Score.Inlog do

  alias Exantenna.Blank
  alias Exantenna.Redis

  @host Application.get_env(:exantenna, Exantenna.Endpoint)[:url][:host]
  @parts "/parts.json"
  @ua_ptn ~r(Mozilla|Opera)
  @accept_ptn ~r/.*(text|html,application|xhtml)/

  # Daily score
  def scoring(%{} = resource) do
    Enum.reduce resource, %{}, fn {url, logs}, acc ->
      result =
        Enum.reduce logs, [], fn l, ac ->
          tpl =
            {to_datetime(l["time"]), l["remote_addr"], l["user-agent"]}

          ac ++
            if tpl in ac, do: [], else: [tpl]
        end

      Map.put(acc, url, length(result))
    end
  end

  def resource(urls) when is_list(urls) do
    allows = Enum.filter(Redis.Inlog.inlogs, &inlog?(&1))
    Redis.Inlog.clear

    Enum.reduce urls, %{}, fn url, acc ->
      r =
        Enum.filter allows, fn log ->
          String.contains?(log["referer"], url)
        end

      Map.put acc, url, r
    end
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
    "accept" => accept, "user-agent" => ua,
    "request_uri" => requri
  }) do

    accept =
      Enum.filter String.split(accept, "/"), fn text ->
        Regex.match?(@accept_ptn, text)
      end

    cond do
      ! Regex.match?(@ua_ptn, ua) ->
        false
      Blank.blank?(ref) ->
        false
      String.contains?(ref, @host) ->
        false
      String.contains?(requri, @parts) ->
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

  defp to_datetime(millisec) do
    {timestamp, _} =
      millisec
      |> Float.to_string
      |> String.split(".")
      |> List.first
      |> Integer.parse

    timestamp
    |> Timex.DateTime.from_seconds
    |> Timex.format!("%Y%m%d%H", :strftime)
  end

end
