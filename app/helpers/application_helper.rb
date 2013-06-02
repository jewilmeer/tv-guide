module ApplicationHelper
  def page_title(title)
    content_for(:title) do
      "- #{title}"
    end
  end
  def ui_icon type
    content_tag :button, type.humanize, :class => type
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

  def meta_description description
    content_for(:meta_description) { description }
  end
end
