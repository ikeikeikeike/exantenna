defmodule Exantenna.Entry do
  use Exantenna.Web, :model

  schema "entries" do

    has_many :thumbs, {"entries_thumbs", Exantenna.Thumb}, foreign_key: :assoc_id

    timestamps
  end

  @required_fields ~w()
  @optional_fields ~w()

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
