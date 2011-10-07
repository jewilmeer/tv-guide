ActiveAdmin.register ProgramPreference do
  
  index do
    column :id
    column 'User' do |p|
      link_to p.user.login, active_admin_user_path(p.user)
    end
    column 'Program' do |p|
      link_to p.program.name, active_admin_program_path(p.program)
    end
    column 'Format' do |p|
      link_to p.search_term_type.name, active_admin_search_term_type_path(p.search_term_type)
    end
    column :download do |p|
      icon_tag(p.download ? 'accept' : 'delete')
    end
    column :created_at
    column :updated_at
    default_actions
  end
end
