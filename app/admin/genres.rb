ActiveAdmin.register Genre do
  index do
     column :id
     column :name
     column "Nr of programs" do |g|
       link_to g.programs.count
     end
     column :created_at
     column :updated_at
     default_actions
  end
end
