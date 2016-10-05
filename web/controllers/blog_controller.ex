defmodule Exantenna.BlogController do
  use Exantenna.Web, :controller

  alias Exantenna.Blog
  alias Exantenna.Video
  alias Exantenna.Picture
  alias Exantenna.Antenna

  alias Exantenna.Filter
  alias Exantenna.Ecto.Q
  alias Exantenna.Es.Paginator

  import Ecto.Query

  def show(conn, %{"id" => id} = params) do
    blog = Repo.get_by!(Blog.query_all(1), id: id)

    queryable =
      Antenna.query_all(:index)
      |> Exantenna.Domain.Q.allowed_join(conn)

    queryable =
      from q in queryable,
        where: q.blog_id == ^id,
        order_by: [desc: q.id]

    unless Q.exists?(queryable),
      do: raise Ecto.NoResultsError.exception queryable: queryable

    pager =
      queryable
      |> Repo.paginate(params)
      |> Paginator.addition

    render(conn, "show.html", blog: blog, pager: pager)
  end

  def show(conn, %{"id" => _id, "title" => _title} = params) do
    show conn, params
  end

end
