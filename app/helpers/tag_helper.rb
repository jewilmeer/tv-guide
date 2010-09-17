module TagHelper
  def icon_tag(icon, options = {})
    image_tag("icons/combined/24x24/#{icon}.png", options.merge({:size => '24x24'}))
  end
end
