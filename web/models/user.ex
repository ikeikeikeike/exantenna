defmodule Exantenna.User do
  use Exantenna.Web, :model

  schema "users" do
    field :email, :string
    field :last_logintime, Ecto.DateTime

    has_many :authorizations, Exantenna.Authorization

    timestamps
  end

  @required_fields ~w(email)
  @optional_fields ~w()

  @doc false
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
  end
end
