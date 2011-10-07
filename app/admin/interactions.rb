ActiveAdmin.register Interaction do
  index do
    column :id
    column :user_id do |i|
      if i.user
        link_to i.user.login, active_admin_user_path(i.user)  
      else
        link_to '-'
      end
    end
    column :program
    column :episode do |i|
      link_to i.episode.full_episode_title, admin_episode_path(i.episode)
    end
    column :interaction_type do |i|
      i.interaction_type.humanize
    end
    column :created_at
    default_actions
  end
end
