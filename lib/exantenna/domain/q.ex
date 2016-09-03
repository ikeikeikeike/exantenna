defmodule Exantenna.Domain.Q do
  import Ecto.Query, only: [from: 1, from: 2]

  alias Exantenna.Repo
  alias Exantenna.Video
  alias Exantenna.Picture
  alias Exantenna.Filter

  def allowed_join(queryable, conn) do
    case Exantenna.Domain.Filter.what(conn) do
      "video" ->
        from q in queryable,
          join: c in Video,
          where: q.video_id == c.id
            and c.elements >= ^Filter.allow_video_elements
      "book"  ->
        from q in queryable,
          join: c in Picture,
          where: q.picture_id == c.id
            and c.elements >= ^Filter.allow_picture_elements
      _       ->
        queryable
    end
  end

end
