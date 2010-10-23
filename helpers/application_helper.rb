module ApplicationHelper
  def page_title(title)
    content_for(:title) do
      "- #{title}"
    end
  end
  def ui_icon type
    content_tag :button, type.humanize, :class => type
  end
end
