defmodule Exantenna.Tmpuser do
  use Exantenna.Web, :model

  schema "tmpusers" do

    field :rss, :string
    field :email, :string

    field :encrypted_password, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    field :mediatype, :string
    field :contenttype, :string

    field :token, :string
    field :tokentype, :string
    field :expires, Timex.Ecto.DateTime

    timestamps
  end

  @required_fields ~w()
  @optional_fields ~w(rss email password password_confirmation mediatype contenttype token tokentype expires)

  @tokentypes ~w(changemail reset signup)
  @mediatypes ~w(image movie)
  @contenttypes ~w(second_dimension third_dimention)

  def register_changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_required(~w(rss email password password_confirmation mediatype contenttype)a)
    |> validate_format(:rss, ~r/^https?:\/\//)
    # |> validate_rss_format_and_connection  TODO:
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 5)
    |> validate_confirmation(:password)
    |> validate_inclusion(:mediatype, @mediatypes)
    |> validate_inclusion(:contenttype, @contenttypes)
    |> put_change(:token, Ecto.UUID.generate)
    |> put_change(:tokentype, "signup")
    |> put_change(:expires, Timex.shift(Timex.DateTime.now, days: 1))
  end

  def register_confirmation_query(token) do
    from q in __MODULE__,
    where: q.token == ^token
       and q.expires > ^Ecto.DateTime.utc
       and q.tokentype == "signup"
  end

end
