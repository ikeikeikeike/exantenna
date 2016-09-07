defmodule Exantenna.SchemaOrg do

  alias Exantenna.Tag
  alias Exantenna.Char
  alias Exantenna.Diva
  alias Exantenna.Toon
  alias Exantenna.Antenna

  alias Exantenna.Ecto.Extractor

  import Exantenna.Gettext

  def person(title, %Antenna{} = model) do
    people =
      Enum.map model.divas, fn diva ->
        person title, diva
      end

    people ++ Enum.flat_map model.toons, fn toon ->
      person(title, toon) ++ Enum.map toon.chars, fn char ->
        person title, char
      end
    end
  end

  def image_object(title, %Antenna{} = model) do
    thumbs =
      Extractor.defget(model.picture.thumbs, [])
      ++ Extractor.defget(model.entry.thumbs, [])

    total = length thumbs

    objects =
      thumbs
      |> Enum.with_index(1)
      |> Enum.map(fn {thumb, index} ->
        %{
          "@type" => "ImageObject",
          "name" => "#{index}/#{total} #{title}",
          "caption" => "#{index}/#{total} #{model.metadata.seo_title}",
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

    objects =
      objects ++ Enum.flat_map model.divas, fn diva ->
        image_object title, diva
      end

    objects ++ Enum.flat_map model.toons, fn toon ->
      image_object(title, toon)
         ++ Enum.flat_map toon.chars, fn char ->
              image_object title, char
            end
      end
  end

  def person(title, %Toon{thumbs: _thumbs} = model) do
    model.chars
    |> Enum.map(&person(title, &1))
  end

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
      "affiliation" => Enum.map(Extractor.defget(model.toons, []), &affiliation(title, &1))
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

  def image_object(name, %{thumbs: thumbs, author: _, works: _} = model) do
    total = length thumbs

    thumbs
    |> Enum.with_index(1)
    |> Enum.map(fn {thumb, index} ->
      %{
        "@type" => "ImageObject",
        "name" => "#{index}/#{total} #{name}",
        "caption" => "#{index}/#{total} #{model.outline}",
        # "keywords" => "",
        "author" => model.author,
        "publisher" => model.works,
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

  def image_object(title, %{thumbs: thumbs, outline: _} = model) do
    total = length thumbs

    thumbs
    |> Enum.with_index(1)
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

end
