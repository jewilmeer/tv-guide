ActiveAdmin.register User do
  index do
    column :id
    column :login
    column :email
    column "Nr of programs", :programs_count
    column :trusted do |u|
      icon_tag( u.trusted ? 'accept' : 'delete')
    end
    column :admin do |u|
      icon_tag( u.admin ? 'accept' : 'delete')
    end
    column :last_request_at
    column :current_login_at
    default_actions
  end
  
  filter :id
  filter :login
  filter :email
  filter :login_count
  filter :programs_count
  filter :interactions_count
end
