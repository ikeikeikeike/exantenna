defmodule Exantenna.BlogController do
  use Exantenna.Web, :controller

  alias Exantenna.Blog
  alias Exantenna.Video
  alias Exantenna.Picture
  alias Exantenna.Antenna

  alias Exantenna.Filter
  alias Exantenna.Es.Paginator

  import Ecto.Query

  def show(conn, %{"id" => id} = params) do
    blog = Repo.get_by!(Blog.query_all(1), id: id)
    qs = Antenna.query_all(:index)

    queryable =
      case Exantenna.Domain.Filter.what(conn) do
        "video" ->
          from q in qs, join: c in Video, where: c.elements >= ^Filter.allow_video_elements
        "book"  ->
          from q in qs, join: c in Picture, where: c.elements >= ^Filter.allow_picture_elements
        _       ->
          from q in qs
      end

    pager =
      queryable
      |> where([q], q.blog_id == ^id)
      |> order_by([q], [desc: q.id])
      |> Repo.paginate(params)
      |> Paginator.addition

    render(conn, "show.html", blog: blog, pager: pager)
  end

  def show(conn, %{"id" => _id, "title" => _title} = params) do
    show conn, params
  end


end
