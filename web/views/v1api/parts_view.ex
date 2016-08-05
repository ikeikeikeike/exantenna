defmodule Exantenna.V1Api.PartsView do
  use Exantenna.Web, :view

  alias Exantenna.Ecto.Extractor

  def render("parts.json", %{antennas: antennas}) when is_list(antennas) do
    Phoenix.View.render_many(antennas, __MODULE__, "parts.json", as: :antenna)
  end

  def render("parts.json", %{antenna: antenna}) do
    %{
      id: antenna.id,
      blog: antenna.blog,
      metadata: antenna.metadata,
      video: antenna.video,
      divas: antenna.divas,
      toons: antenna.toons,
      tags: Enum.map(Extractor.tag(antenna), &(&1.name)),
      thumbs: Enum.map(Extractor.thumb(antenna), &(&1.src)),
      # scores: ,
    }
  end

end
