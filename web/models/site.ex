defmodule Exantenna.Site do
  use Exantenna.Web, :model

  schema "sites" do
    has_one :video_metadata, Exantenna.VideoMetadata
    has_many :thumbs, {"sites_thumbs", Exantenna.Thumb}, foreign_key: :assoc_id, on_delete: :delete_all

    field :name, :string

    field :url, :string
    field :domain, :string

    field :rss, :string

    timestamps
  end

  @required_fields ~w(domain)
  @optional_fields ~w(name rss url)

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def get_or_changeset(model, %{"url" => url}),
    do: get_or_changeset(model, %{url: url})
  def get_or_changeset(model, %{url: url}) do
    u = URI.parse(url)

    case Exantenna.Ecto.Changeset.get_or_changeset(model, %{domain: u.host}) do
      %Site{} = model ->
        model
      cset ->
        cset
        |> update_change(:url, URI.to_string(%URI{scheme: u.scheme, host: u.host}))
        |> update_change(:name, u.host)
        |> update_change(:domain, u.host)
    end
  end

end
