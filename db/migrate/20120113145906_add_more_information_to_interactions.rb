class AddMoreInformationToInteractions < ActiveRecord::Migration
  def change
    add_column :interactions, :user_agent, :string 
    add_column :interactions, :referer, :string
  end
end
