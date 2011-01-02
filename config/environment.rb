# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
TvEpisodes::Application.initialize!

Sass::Plugin.options[:style] = :compressed

ActiveSupport::Dependencies.log_activity = true

ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  if html_tag.match(/^\<input/)
    if instance.error_message.kind_of?(Array)
      %(#{html_tag}<span class="validation-error">#{instance.error_message.join(', ')}</span>).html_safe
    else
      %(#{html_tag}<span class="validation-error">#{instance} #{instance.error_message}</span>).html_safe
    end
  else
    html_tag
  end
end
