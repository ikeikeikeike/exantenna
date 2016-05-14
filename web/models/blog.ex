defmodule Exantenna.Blog do
  use Exantenna.Web, :model

  schema "blogs" do
    field :name, :string

    field :url, :string
    field :rss, :string

    field :mediatype, :string
    field :adtype, :string

    field :penalty, :string, default: "beginning"  # beginning, soft, hard, ban
    field :last_modified, Ecto.DateTime

    has_many :verifiers, Exantenna.BlogVerifier

    timestamps
  end

  @required_fields ~w(name url rss mediatype adtype penalty last_modified)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
