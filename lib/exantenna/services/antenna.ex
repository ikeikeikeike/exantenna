defmodule Exantenna.Services.Antenna do
  alias Exantenna.Repo
  alias Exantenna.Antenna

  require Logger

  def update_by_feed(feed) do
    Enum.each feed, fn f ->
      video = Redis.video_get f.url
      picture = Redis.picture_get f.url
    end
  end

end
