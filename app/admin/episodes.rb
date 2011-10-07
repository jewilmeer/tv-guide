ActiveAdmin.register Episode do
  scope :last_aired do |episodes|
    episodes.last_aired.order('airs_at desc')
  end
  scope :next_airing do |episodes|
    episodes.next_airing.order('airs_at asc')
  end
  index do
    column :id do |e|
      link_to e.id, e
    end
    column :tvdb_id
    column :program_name
    column :full_episode_title
    column :airs_at
    column 'Aired?' do |e|
      icon_tag( e.airs_at.try(:future?) ? "delete" : "accept" )
    end
    column 'image' do |e|
      icon_tag(e.image ? "accept" : "delete")
    end
    default_actions
  end
end
