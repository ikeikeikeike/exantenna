defmodule Exantenna.BlogVerifier do
  use Exantenna.Web, :model

  schema "blog_verifiers" do
    field :name, :string   # parts, rss, link, book_rss, book_link, video_rss, video_link
    field :state, :integer

    belongs_to :blog, Exantenna.Blog

    timestamps
  end

  @required_fields ~w(name state)
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
