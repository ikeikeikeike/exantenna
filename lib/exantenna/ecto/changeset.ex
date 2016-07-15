defmodule Exantenna.Ecto.Changeset do
  # alias Exantenna.Repo
  # import Ecto
  import Ecto.Changeset
  # import Ecto.Query, only: [from: 1, from: 2]

  # for profile
  def profile_changeset(changeset) do
    changeset
    |> update_change(:kana,   &String.replace(&1 || "", ~r/(-|_)/, ""))
    |> update_change(:romaji, &String.replace(String.downcase(&1 || ""), ~r/(-|_)/, ""))
    |> update_change(:blood,  &String.replace(String.upcase(&1 || ""), ~r/[^A|B|AB|O|RH|\+|\-]/i, ""))
    |> update_change(:bracup, &String.replace(String.upcase(&1 || ""), ~r/(カップ|CUP| |\(|\))/iu, ""))
    |> validate_format(:romaji, ~r/^[a-z]\w+$/)  # TODO: Make sure that constains blank value
  end

  def rubytext_changeset(changeset) do
    changeset
    |> update_change(:kana, &String.replace(&1 || "", ~r/(-|_)/, ""))
    |> update_change(:romaji, &String.replace(String.downcase(&1 || ""), ~r/(-|_)/, ""))
    |> validate_format(:romaji, ~r/^[a-z]\w+$/)
  end

end
