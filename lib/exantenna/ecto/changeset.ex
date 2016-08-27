defmodule Exantenna.Ecto.Changeset do
  import Ecto.Changeset

  alias Exantenna.Repo
  alias Exantenna.Redis.Imginfo

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

  def thumbs_changeset(changeset, srcs) do
    thumbs = Enum.map(srcs, fn src ->
      case Imginfo.get(src) do
        nil -> %{"src" => src}
        inf -> inf
      end
    end)

    mergeset =
      changeset.data
      |> cast(%{"thumbs" => thumbs}, [])
      |> cast_assoc(:thumbs, required: false)

    merge(changeset, mergeset)
  end

  def get_or_changeset(mod, queryables) when is_list(queryables),
    do: Enum.map queryables, &get_or_changeset(mod, &1)
  def get_or_changeset(mod, queryable) do
    case Repo.get_by(mod, queryable) do
      nil ->
        apply mod, :changeset, [mod.__struct__, queryable]
      model ->
        model
    end
  end

end
