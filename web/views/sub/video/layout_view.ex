defmodule Exantenna.Sub.Video.LayoutView do
  use Exantenna.Web, :view

  def page_title(conn, assigns) do
    try do
      apply(view_module(conn), :page_title, [action_name(conn), assigns])
    rescue
      UndefinedFunctionError -> default_page_title(conn, assigns)
    end
  end

  def page_description(conn, assigns) do
    try do
      apply(view_module(conn), :page_description, [action_name(conn), assigns])
    rescue
      UndefinedFunctionError -> default_page_description(conn, assigns)
    end
  end

  def page_keywords(conn, assigns) do
    try do
      apply(view_module(conn), :page_keywords, [action_name(conn), assigns])
    rescue
      UndefinedFunctionError -> default_page_title(conn, assigns)
    end
  end

  def page_author(conn, assigns) do
    try do
      apply(view_module(conn), :page_author, [action_name(conn), assigns])
    rescue
      UndefinedFunctionError -> default_page_author(conn, assigns)
    end
  end

  def default_page_title(_conn, _assigns),       do: gettext "Default Page Title"
  def default_page_author(_conn, _assigns),      do: gettext "Default Page Author"
  def default_page_keywords(_conn, _assigns),    do: gettext "Default,Page,Keywords"
  def default_page_description(_conn, _assigns), do: gettext "Default Page Description"


end
