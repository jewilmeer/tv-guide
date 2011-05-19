ActiveAdmin.register Interaction do
  index do
    column :user_id do |i|
      i.user_id
      # link_to i.user.login, active_admin_user_path(i.user)
    end
    column :interaction_type do |i|
      i.interaction_type.humanize
    end
    default_actions
  end
end
