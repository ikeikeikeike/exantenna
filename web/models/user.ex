defmodule Exantenna.User do
  use Exantenna.Web, :model

  schema "users" do
    field :email, :string

    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    field :encrypted_password, :string

    field :last_logintime, Timex.Ecto.DateTime

    has_many :blogs, Exantenna.Blog
    has_many :authorizations, Exantenna.Authorization

    timestamps
  end

  @required_fields ~w()
  @optional_fields ~w(email password password_confirmation encrypted_password last_logintime)

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def register_changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_required(~w(email encrypted_password)a)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end

  def changemail_changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_required(~w(email password password_confirmation encrypted_password)a)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> validate_length(:password, min: 5)
    |> validate_confirmation(:password)
    |> Exantenna.Auth.Changeset.validate_password(:password)
  end

  def with_blogs(model) do
    model
    |> Repo.preload(blogs: :verifiers)
  end

end
