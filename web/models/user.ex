defmodule Exantenna.User do
  use Exantenna.Web, :model

  schema "users" do
    field :email, :string
    field :encrypted_password, :string
    field :last_logintime, Ecto.DateTime

    has_many :blogs, Exantenna.Blog
    has_many :authorizations, Exantenna.Authorization

    timestamps
  end

  @required_fields ~w(email password)
  @optional_fields ~w()

  @doc false
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def validate_password(changeset, field) do
    value = get_field(changeset, field)
    if Comeonin.Pbkdf2.checkpw(value, "encrypted_password") do
      changeset
    else
      add_error(changeset, field, "does not contain '@'")
    end
  end

end
