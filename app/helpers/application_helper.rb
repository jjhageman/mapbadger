module ApplicationHelper
  FLASH_CLASS = {'notice' => 'alert-success', 'error' => 'alert-error'}
  
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class}
  end

  def tab_li(name, path)
    "<li#{' class="active"' if current_page?(path)}>#{link_to name, path}</li>".html_safe
  end

  def nav_li(name, path)
    "<li#{' class="current"' if current_page?(path)}>#{link_to_unless_current name, path}</li>".html_safe
  end

  def bootstrap_alert_class(key)
    return key unless FLASH_CLASS.has_key?(key)
    FLASH_CLASS[key]
  end
end
