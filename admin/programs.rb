ActiveAdmin.register Program do
  index do 
    column :id
    column :name
    column :status
    column :images do |p|
      buffer = ""
      buffer << "#{icon_tag(p.fanart_image ? 'accept' : 'delete', :alt => 'fanart_image')}"
      buffer << "#{icon_tag( p.series_image ? 'accept' : 'delete', :alt => 'series_image')}"
      buffer.html_safe
    end
    column :updated_at
    column :created_at
      
    default_actions
  end
end
