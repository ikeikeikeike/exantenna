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
  @optional_fields ~w(count updated_at)

  @names ~w(
    domain
    in_hourly in_daily in_weekly in_monthly in_quarterly in_biannually in_yearly in_totally
    out_hourly out_daily out_weekly out_monthly out_quarterly out_biannually out_yearly out_totally
    tag_appeared char_appeared diva_appeared toon_appeared
    book_tag_appeared book_char_appeared book_diva_appeared book_toon_appeared
    video_tag_appeared video_char_appeared video_diva_appeared video_toon_appeared
  )

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_inclusion(:name, @names)
  end

  @names
  |> Enum.each fn name ->
    def unquote(:"const_#{name}")() do
      unquote name
    end
  end

  @names
  |> Enum.each fn name ->
    def unquote(:"get_#{name}")(model) when is_list(model) do
      model
      |> Enum.filter(& &1.name == "#{unquote(name)}")
      |> List.first
    end
  end

  def name_table(name) when is_bitstring(name), do: "#{name}s_scores"
  def name_table(model), do: name_table(Exantenna.Ecto.Extractor.toname model)

  def name_appeared(name), do: "#{name}_appeared"
  def name_appeared(subdomain, name), do: "#{subdomain}_#{name}_appeared"

  def appeared(model, subdomain, name) when is_list(model) do
    model
    |> Enum.filter(& &1.name == "#{subdomain}_#{name}_appeared")
    |> List.first
  end
  def appeared(model, name) when is_list(model) do
    model
    |> Enum.filter(& &1.name == "#{name}_appeared")
    |> List.first
  end

end
