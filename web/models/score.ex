defmodule Exantenna.Score do
  use Exantenna.Web, :model

  @primary_key false
  schema "scores" do
    field :assoc_id, :integer, primary_key: true
    field :name, :string, primary_key: true
    field :count, :integer, default: 0

    timestamps
  end

  @required_fields ~w(assoc_id name)
  @optional_fields ~w(count)

  @names ~w(
    domain
    in_daily in_weekly in_monthly in_yearly in_totally
    out_daily out_weekly out_monthly out_yearly out_totally
    tag_appeared char_appeared diva_appeared toon_appeared
    book_tag_appeared book_char_appeared book_diva_appeared book_toon_appeared
    video_tag_appeared video_char_appeared video_diva_appeared video_toon_appeared
  )

  def name_appeared(name), do: "#{name}_appeared"
  def name_appeared(subdomain, name), do: "#{subdomain}_#{name}_appeared"

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_inclusion(:name, @names)
  end

end
