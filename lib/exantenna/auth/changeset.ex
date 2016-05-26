defmodule Exantenna.Auth.Changeset do
  alias Ecto.Changeset

  def validate_password(changeset, field, password) do
    encrypted_password = Changeset.get_field(changeset, field)
    if Comeonin.Pbkdf2.checkpw(password, encrypted_password) do
      changeset
    else
      Changeset.add_error(changeset, field, "didnt match password")
    end
  end

  def generate_password(changeset, field) do
    pass = Comeonin.Pbkdf2.hashpwsalt(changeset.params["password"])
    Changeset.put_change(changeset, field, pass)
  end

end
