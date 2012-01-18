module ApplicationHelper
  def tab_li(name, path)
    "<li#{' class="active"' if current_page?(path)}>#{link_to name, path}</li>".html_safe
  end
end
