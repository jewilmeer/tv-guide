ActiveAdmin.register Episode do
  scope :last_aired, :default => true
  scope :next_airing
  
  index do
    column :id do |e|
      link_to e.id, e
    end
    column :tvdb_id
    column :program_name
    column :full_episode_title
    column :airs_at
    column 'Aired?' do |e|
      icon_tag( e.airs_at.future? ? "delete" : "accept" )
    end
    column 'image' do |e|
      icon_tag(e.image ? "accept" : "delete")
    end
    default_actions
  end
  
  filter :id
end
