defmodule Exantenna.Admin.BlogController do
  use Exantenna.Web, :controller

  alias Exantenna.User
  alias Exantenna.Blog
  alias Exantenna.BlogVerifier

  plug AuthPlug.LoginRequired
  plug AdminPlug.AssignUser
  plug :put_layout, {Exantenna.Admin.LayoutView, "app.html"}

  def index(conn, _params) do
    render conn, "index.html"
  end

  def new(conn, _params) do
    blog = %Blog{verifiers: BlogVerifier.named_structs}

    changeset = Blog.changeset(blog)

    render conn, "new.html", blog: nil, changeset: changeset
  end

  def create(conn, %{"blog" => blog_params} = _params) do
    user = User.with_blogs(Guardian.Plug.current_resource(conn))
    blog_params = Map.merge(blog_params, %{"user_id" => user.id})

    changeset = Blog.verifiers_changeset(%Blog{}, blog_params)

    case Repo.insert(changeset) do
      {:ok, blog} ->
        conn
        |> put_flash(:info, gettext("%{name} created successfully.", name: "Blog"))
        |> redirect(to: admin_blog_path(conn, :edit, blog))

      {:error, changeset} ->
        render(conn, "new.html", blog: nil, changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    blog = Repo.get!(Blog, id) |> Repo.preload(:verifiers)
    changeset = Blog.changeset(blog)

    render conn, "edit.html", blog: blog, changeset: changeset
  end

  def update(conn, %{"id" => id, "blog" => blog_params}) do
    blog = Repo.get!(Blog, id) |> Repo.preload(:verifiers)
    changeset = Blog.verifiers_changeset(blog, blog_params)

    case Repo.update(changeset) do
      {:ok, _blog} ->
        conn
        |> put_flash(:info, gettext("%{name} updated successfully.", name: "Blog"))
        |> redirect(to: admin_blog_path(conn, :index))

      {:error, changeset} ->
        render(conn, "edit.html", blog: blog, changeset: changeset)
    end
  end

end
