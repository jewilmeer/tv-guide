module TagHelper
  def icon_tag(icon, options = {})
    image_tag("icons/combined/16x16/#{icon}.png", options.merge({:size => '16x16', :class => :icon}))
  end
end
