defmodule Exantenna.BlogController do
  use Exantenna.Web, :controller

  alias Exantenna.Antenna
  alias Exantenna.Blog
  alias Exantenna.Es.Paginator

  import Ecto.Query

  def show(conn, %{"id" => id} = params) do
    blog = Repo.get_by!(Blog.query_all(1), id: id)

    pager =
      Antenna.query_all
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
