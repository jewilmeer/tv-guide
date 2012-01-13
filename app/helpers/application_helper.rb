module ApplicationHelper
  def page_title(title)
    content_for(:title) do
      "- #{title}"
    end
  end
  def ui_icon type
    content_tag :button, type.humanize, :class => type
  end
  
  def sortable(column, title = nil)
    title ||= column.to_s.titleize
    css_class = column == sort_column ? "sorted #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, params.merge({:sort => column, :direction => direction}), {:class => css_class}
  end

  def formatted_user_agent subject
    return unless subject.present?

    agent = Agent.new subject

    if agent.name && agent.version && agent.os
      return %(#{agent.name} #{agent.version} (#{agent.os}))
    end
    case subject
    when /Firefox/
      version = subject.match('Firefox/(.*)$')[1]
      return %(Firefox #{version} (#{agent.os}))
    when /Sabnzb/i
      subject.split('/').join ' '

    else 
      'unknown user agent'
    end
  end
end
