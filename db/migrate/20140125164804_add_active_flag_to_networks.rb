class AddActiveFlagToNetworks < ActiveRecord::Migration
  def change
    add_column :networks, :active, :boolean, default: true, null: false
  end
end
