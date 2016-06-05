defmodule Exantenna.Authorization do
  use Exantenna.Web, :model

  schema "authorizations" do
    field :provider, :string
    field :uid, :string
    field :token, :string
    field :refresh_token, :string
    field :expires_at, :integer

    belongs_to :user, Exantenna.User

    timestamps
  end

  @required_fields ~w(provider uid user_id token)
  @optional_fields ~w(refresh_token expires_at)

  @doc false
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> foreign_key_constraint(:user_id)
    |> unique_constraint(:provider_uid)
  end
end
