defmodule Exantenna.SchemaOrg do

  alias Exantenna.Tag
  alias Exantenna.Char
  alias Exantenna.Diva
  alias Exantenna.Toon
  alias Exantenna.Antenna

  import Exantenna.Gettext

  # def person(title, %Antenna{} = model)
  # def image_object(title, %Antenna{} = model)

  def person(title, %Diva{thumbs: _thumbs} = model) do
    %{
      "@type" => "Person",
      "name" => model.name,
      "description" => model.outline,
      "disambiguatingDescription" => title,
      "birthDate" => model.birthday,
      "birthPlace" => "Japan",
      "alternateName" => model.alias,
      "gender" => "Female",
      # "url" => "",
      "jobTitle" => gettext("Diva Job"),
      "height" => model.height,
      "weight" => model.weight,
      "bust" =>  model.bust,
      "bracup" =>  model.bracup,
      "waist" =>  model.waist,
      "hip" =>  model.hip,
      "bloodType" => model.blood,
      "image" => image_object(title, model)
    }
  end

  def person(title, %Toon{thumbs: _thumbs} = model) do
    model.chars
    |> Enum.map(&person(title, &1))
  end

  def person(title, %Char{thumbs: _thumbs} = model) do
    %{
      "@type" => "Person",
      "name" => model.name,
      "description" => model.outline,
      "disambiguatingDescription" => title,
      "birthDate" => model.birthday,
      "birthPlace" => "Japan",
      "alternateName" => model.alias,
      "gender" => "Female",
      # "url" => "",
      "jobTitle" => gettext("Diva Job"),
      "height" => model.height,
      "weight" => model.weight,
      "bust" =>  model.bust,
      "bracup" =>  model.bracup,
      "waist" =>  model.waist,
      "hip" =>  model.hip,
      "bloodType" => model.blood,
      "image" => image_object(title, model),
      "affiliation" => affiliation(title, model)
    }
  end

  def affiliation(title, %Toon{thumbs: _thumbs} = model) do
    %{
      "@type" => "ProgramMembership",
      "name" => model.name,
      "url" => model.url,
      "description" => model.outline,
      "members" => person(title, model)
    }
  end

  def affiliation(title, %Char{thumbs: _thumbs} = model) do
    model.toons
    |> Enum.map(&affiliation(title, &1))
  end

  def image_object(title, %Diva{thumbs: thumbs} = model) do
    total = length thumbs

    thumbs
    |> Enum.with_index
    |> Enum.map(fn {thumb, index} ->
      %{
        "@type" => "ImageObject",
        "name" => "#{index}/#{total} #{title}",
        "caption" => "#{index}/#{total} #{model.outline}",
        # "keywords" => "",
        "uploadDate	" => thumb.inserted_at,
        "thumbnail" => thumb.src,
        "contentUrl" => thumb.src,
        "width" => thumb.width,
        "height" => thumb.height,
        "encodingFormat" => thumb.ext,
        "fileFormat" => thumb.mime,
      }
    end)
  end

  def image_object(name, %Toon{thumbs: thumbs} = model) do
    total = length thumbs

    thumbs
    |> Enum.with_index
    |> Enum.map(fn {thumb, index} ->
      %{
        "@type" => "ImageObject",
        "name" => "#{index}/#{total} #{name}",
        "caption" => "#{index}/#{total} #{model.outline}",
        # "keywords" => "",
        "author" => model.author,
        "publisher" => model.works,
        "genre" => "Toon",
        "uploadDate	" => thumb.inserted_at,
        "thumbnail" => thumb.src,
        "contentUrl" => thumb.src,
        "width" => thumb.width,
        "height" => thumb.height,
        "encodingFormat" => thumb.ext,
        "fileFormat" => thumb.mime,
      }
    end)

  end

end
