module ApplicationHelper
  def tab_li(name, path)
    "<li#{' class="active"' if current_page?(path)}>#{link_to name, path}</li>".html_safe
  end

  def nav_li(name, path)
    "<li#{' class="current"' if current_page?(path)}>#{link_to_unless_current name, path}</li>".html_safe
  end
end
