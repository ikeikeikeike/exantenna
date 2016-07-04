defmodule Exantenna.Blog do
  use Exantenna.Web, :model

  schema "blogs" do
    field :name, :string
    # field :explain, :string

    field :url, :string
    field :rss, :string

    field :mediatype, :string
    field :contenttype, :string

    field :last_modified, Timex.Ecto.DateTime

    belongs_to :user, Exantenna.User

    has_one :antenna, Exantenna.Antenna
    has_one :thumb, {"blogs_thumbs", Exantenna.Thumb}, foreign_key: :assoc_id
    has_one :penalty, {"blogs_penalties", Exantenna.Penalty}, foreign_key: :assoc_id

    has_many :scores, {"blogs_scores", Exantenna.Score}, foreign_key: :assoc_id
    has_many :verifiers, Exantenna.BlogVerifier

    timestamps
  end

  @required_fields ~w(rss mediatype contenttype)
  @optional_fields ~w(name url user_id rss last_modified)

  @mediatypes ~w(image movie)
  @contenttypes ~w(second_dimension third_dimention)

  @relational_fields ~w(user antenna thumb penalty scores verifiers)a

  def query do
    from e in __MODULE__,
    preload: ^@relational_fields
  end

  def available(query) do
    from e in query,
      where: e.rss != "" and
             not is_nil(e.rss)
  end

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def register_changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:rss)
    |> validate_required(~w(user_id rss mediatype contenttype)a)
    # |> validate_rss_format_and_connection  TODO:
    |> validate_format(:rss, ~r/^https?:\/\//)
    |> validate_inclusion(:mediatype, @mediatypes)
    |> validate_inclusion(:contenttype, @contenttypes)
  end

  def verifiers_changeset(model, params \\ :invalid) do
    model
    |> register_changeset(params)
    |> cast_assoc(:verifiers, required: true)
  end

  def feed_changeset(model, feed \\ :invalid) do
    params = %{
      url: feed["host"],
      name: feed["title"],
      explain: feed["explain"]
    }

    model
    |> Blog.changeset(params)
  end

end
