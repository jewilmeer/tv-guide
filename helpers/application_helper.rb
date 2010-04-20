module ApplicationHelper
  def ui_icon type
    content_tag :button, type.humanize, :class => type
  end
end
