defmodule Exantenna.V1Api.PartsView do
  use Exantenna.Web, :view

  def render("parts.json", %{antennas: antennas}) when is_list(antennas) do
    Phoenix.View.render_many(antennas, __MODULE__, "parts.json", as: :antenna)
  end

  def render("parts.json", %{antenna: antenna}) do
    %{
      value: "",
      tokens: ""
    }
  end


end
