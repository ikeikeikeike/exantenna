defmodule Exantenna.SchemaOrg do

  alias Exantenna.Tag
  alias Exantenna.Char
  alias Exantenna.Diva
  alias Exantenna.Toon
  alias Exantenna.Antenna

  alias Exantenna.Helpers
  alias Exantenna.Ecto.Extractor

  import Exantenna.Helpers
  import Exantenna.Gettext
  import Exantenna.Router.Helpers

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

  def video_object(%Plug.Conn{} = conn, %Exantenna.Es.Paginator{} = pager) do
    Enum.map(pager.entries, fn maybe ->
      an = anstget maybe
      thumb = choose_thumb an, :entry

      %{
        "@type": "VideoObject",
        "url": entry_path(conn, :show, an.id),
        "name": an.metadata.seo_title,
        "headline": an.metadata.seo_title,
        "description": an.metadata.seo_content,
        "image": (if thumb, do: thumb.src, else: fallback),
        "thumbnailUrl": (if thumb, do: thumb.src, else: fallback),
        "keywords": get_keywords(an),
        "uploadDate": Timex.format!(an.metadata.published_at || an.inserted_at, "{ISOz}")
      }
    end)
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
          "uploadDate" => Timex.format!(thumb.inserted_at),
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
        "uploadDate" => Timex.format!(thumb.inserted_at),
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
        "uploadDate" => Timex.format!(thumb.inserted_at, "{ISOz}"),
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
