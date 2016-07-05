defmodule Exantenna.Summary do
  use Exantenna.Web, :model
  alias Exantenna.Antenna

  schema "summaries" do
    field :sort, :integer

    has_one :antenna, Exantenna.Antenna
    has_many :scores, {"summaries_scores", Exantenna.Score}, foreign_key: :assoc_id

    timestamps
  end

  @required_fields ~w()
  @optional_fields ~w(sort)

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def item_changeset(%Antenna{summary: summary} = _antenna, _item \\ :invalid) do
    abc =
    summary
    |> changeset(%{})
    require IEx; IEx.pry
    abc
  end

end
