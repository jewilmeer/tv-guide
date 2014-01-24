class AddActiveFlagToPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :active, :boolean, default: true
    add_index :programs, :active

    Program.where(network_id: nil, network_name: nil).update_all(active: false)
  end
end
