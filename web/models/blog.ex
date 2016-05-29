defmodule Exantenna.Blog do
  use Exantenna.Web, :model

  schema "blogs" do
    field :name, :string

    field :url, :string
    field :rss, :string

    field :mediatype, :string
    field :contenttype, :string

    field :penalty, :string, default: "beginning"
    field :last_modified, Timex.Ecto.DateTime

    belongs_to :user, Exantenna.User

    has_many :verifiers, Exantenna.BlogVerifier

    timestamps
  end

  @required_fields ~w()
  @optional_fields ~w(name url user_id rss penalty last_modified mediatype contenttype)

  @mediatypes ~w(image movie)
  @contenttypes ~w(second_dimension third_dimention)
  @penaltytypes ~w(beginning soft hard ban)

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def register_changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_required(~w(user_id rss mediatype contenttype)a)
    # |> validate_rss_format_and_connection  TODO:
    |> validate_format(:rss, ~r/^https?:\/\//)
    |> validate_inclusion(:mediatype, @mediatypes)
    |> validate_inclusion(:contenttype, @contenttypes)
  end

end
