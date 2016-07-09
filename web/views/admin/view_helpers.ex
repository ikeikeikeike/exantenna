defmodule Exantenna.Admin.Helpers do
  use Phoenix.HTML
  import Exantenna.Gettext

  alias Exantenna.BlogVerifier
  alias Exantenna.Blog
  alias Exantenna.Repo

  def mediatype_text(mediatype) do
    case mediatype do
      "image" -> gettext("Images primarily")
      "movie" -> gettext("Movies primarily")
    end
  end

  def contenttype_text(mediatype) do
    case mediatype do
      "second_dimension" -> gettext("Toon or Commic primarily")
      "third_dimention"  -> gettext("Idol or Pornstar primarily")
    end
  end

  def verify_link_tag(%Blog{} = blog, name), do: verify_link_tag Repo.one(BlogVerifier.blog_verifier(BlogVerifier, blog, "#{name}_link"))
  def verify_link_tag(%Blog{} = blog), do: verify_link_tag Repo.one(BlogVerifier.blog_verifier(BlogVerifier, blog, "link"))
  def verify_link_tag(verifier) do
    case verifier && verifier.state do
      state when state == 3 ->
        content_tag(:span, title: gettext("Link installation is complete"), data_toggle: "tooltip", data_placement: "top", data_container: "body") do
          raw "(<mark>◎</mark>)"
        end

      state when state == 2 ->
        content_tag(:span, title: gettext("Still confirmation status"), data_toggle: "tooltip", data_placement: "top", data_container: "body") do
          raw "(<mark>○</mark>)"
        end

      _ ->
        content_tag(:span, title: gettext("No link established"), data_toggle: "tooltip", data_placement: "top", data_container: "body") do
          raw "(<mark>☓</mark>)"
        end
    end
  end

  def verify_rss_tag(%Blog{} = blog, name), do: verify_rss_tag Repo.one(BlogVerifier.blog_verifier(BlogVerifier, blog, "#{name}_rss"))
  def verify_rss_tag(%Blog{} = blog), do: verify_rss_tag Repo.one(BlogVerifier.blog_verifier(BlogVerifier, blog, "rss"))
  def verify_rss_tag(verifier) do
    case verifier && verifier.state do
      state when state == 3 ->
        content_tag(:span, title: gettext("RSS installation is complete"), data_toggle: "tooltip", data_placement: "top", data_container: "body") do
          raw "(<mark>◎</mark>)"
        end

      state when state == 2 ->
        content_tag(:span, title: gettext("Still confirmation status"), data_toggle: "tooltip", data_placement: "top", data_container: "body") do
          raw "(<mark>○</mark>)"
        end

      _ ->
        content_tag(:span, title: gettext("No RSS established"), data_toggle: "tooltip", data_placement: "top", data_container: "body") do
          raw "(<mark>☓</mark>)"
        end
    end
  end

  def verify_parts_tag(%Blog{} = blog), do: verify_parts_tag Repo.one(BlogVerifier.blog_verifier(BlogVerifier, blog, "parts"))
  def verify_parts_tag(verifier) do
    case verifier && verifier.state do
      state when state == 3 ->
        content_tag(:span, title: gettext("Blog parts installation is complete"), data_toggle: "tooltip", data_placement: "top", data_container: "body") do
          raw "(<mark>◎</mark>)"
        end

      state when state == 2 ->
        content_tag(:span, title: gettext("Still confirmation status"), data_toggle: "tooltip", data_placement: "top", data_container: "body") do
          raw "(<mark>○</mark>)"
        end

      _ ->
        content_tag(:span, title: gettext("No Blog parts established"), data_toggle: "tooltip", data_placement: "top", data_container: "body") do
          raw "(<mark>☓</mark>)"
        end
    end
  end

end
