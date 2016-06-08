defmodule Exantenna.User do
  use Exantenna.Web, :model

  schema "users" do
    field :email, :string
    field :encrypted_password, :string
    field :last_logintime, Timex.Ecto.DateTime

    has_many :blogs, Exantenna.Blog
    has_many :authorizations, Exantenna.Authorization

    timestamps
  end

  @required_fields ~w()
  @optional_fields ~w(email encrypted_password last_logintime)

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def register_changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_required(~w(email encrypted_password)a)
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
  end

  def with_blogs(model) do
    model
    |> Repo.preload(blogs: :verifiers)
  end

end
