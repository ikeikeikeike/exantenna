defmodule Exantenna.Admin.UserView do
  use Exantenna.Web, :view

  def mediatype_text(mediatype) do
    case mediatype do
      "image" -> gettext("Images primarily")
      "movie" -> gettext("Movies primarily")
    end
  end

  def contenttype_text(mediatype) do
    case mediatype do
      "second_dimension" -> gettext("Anime or Commic primarily")
      "third_dimention"  -> gettext("Idol or Pornstar primarily")
    end
  end
end
