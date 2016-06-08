defmodule Exantenna.BlogVerifier do
  use Exantenna.Web, :model

  schema "blog_verifiers" do
    field :name, :string
    field :state, :integer, default: 1

    belongs_to :blog, Exantenna.Blog

    timestamps
  end

  @required_fields ~w(name)
  @optional_fields ~w(state)

  @names ~w(parts, rss, link, book_rss, book_link, video_rss, video_link)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def blog_verifier(blog) do
    query =
      from q in __MODULE__,
      where: q.blog_id == ^blog.id

    Repo.all(query)
  end
  def blog_verifier(blog, name) do
    query =
      from q in __MODULE__,
      limit: 1,
      where: q.blog_id == ^blog.id
         and q.name > ^name

    Repo.one(query)
  end

end
