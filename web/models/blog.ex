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

    belongs_to :user, Exantenna.User

    has_many :verifiers, Exantenna.BlogVerifier

    timestamps
  end

  @required_fields ~w(name url rss)
  @optional_fields ~w(penalty last_modified mediatype adtype)

  @doc false
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
