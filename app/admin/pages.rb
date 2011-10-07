ActiveAdmin.register Page do
  index do
    column :id
    column :title
    column :permalink do |p|
      link_to p.permalink, p
    end
    column :created_at
    column :updated_at
    default_actions
  end
end
