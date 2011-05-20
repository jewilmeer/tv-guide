ActiveAdmin.register Program do
  index do 
    column :id
    # column :name
    #   column :last_updated_at
      
    default_actions
  end

  filter :id
  
  
end
