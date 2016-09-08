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

  @tokentypes ~w(changemail resetpasswd signup)
  @mediatypes ~w(image movie)
  @contenttypes ~w(second_dimension third_dimention)

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

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

  def changemail_changeset(model, params \\ :invalid) do
    model
    |> cast(params, ~w(email), [])
    |> validate_required(~w(email)a)
    |> validate_format(:email, ~r/@/)
    |> put_change(:token, Ecto.UUID.generate)
    |> put_change(:tokentype, "changemail")
    |> put_change(:expires, Timex.shift(Timex.DateTime.now, days: 1))
  end

  def resetpasswd_changeset(model, params \\ :invalid) do
    model
    |> cast(params, ~w(email), [])
    |> validate_required(~w(email)a)
    |> validate_format(:email, ~r/@/)
    |> put_change(:token, Ecto.UUID.generate)
    |> put_change(:tokentype, "resetpasswd")
    |> put_change(:expires, Timex.shift(Timex.DateTime.now, days: 1))
  end

  def confirmation(:signup, model, token), do: confirmation :register, model, token
  def confirmation(:register, model, token) do
    from q in model,
      where: q.token == ^token
         and q.expires > ^Ecto.DateTime.utc
         and q.tokentype == "signup"
  end

  def confirmation(:resetpasswd, model, token) do
    from q in model,
      where: q.token == ^token
         and q.expires > ^Ecto.DateTime.utc
         and q.tokentype == "resetpasswd"
  end

  def confirmation(:changemail, model, token) do
    from q in model,
      where: q.token == ^token
         and q.expires > ^Ecto.DateTime.utc
         and q.tokentype == "changemail"
  end

end
