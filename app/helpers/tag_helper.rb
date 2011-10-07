module TagHelper
  def icon_tag(icon, options = {})
    default_options = {:size => '16x16'}
    options = default_options.merge(options)
    image_tag("icons/combined/#{options[:size]}/#{icon}.png", options.merge({:size => options[:size], :class => "icon #{icon}"}))
  end
end
