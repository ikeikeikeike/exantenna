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
    field :expires, Ecto.DateTime

    timestamps
  end

  @required_fields ~w()
  @optional_fields ~w(rss email password password_confirmation mediatype contenttype token tokentype expires)

  @tokentypes ~w(changemail reset signup)
  @mediatypes ~w(image movie)
  @contenttypes ~w(second_dimension third_dimention)

  @doc false
  def register_changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:email)
    |> validate_required(~w(rss email password password_confirmation mediatype contenttype)a)
    |> validate_format(:rss, ~r/^https?:\/\//)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 5)
    |> validate_confirmation(:password)
    |> validate_inclusion(:mediatype, @mediatypes)
    |> validate_inclusion(:contenttype, @contenttypes)
  end

  def generate_password(changeset) do
    put_change(changeset, :encrypted_password, Comeonin.Pbkdf2.hashpwsalt(changeset.params["password"]))
  end

end
