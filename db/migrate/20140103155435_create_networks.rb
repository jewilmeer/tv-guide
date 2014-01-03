class CreateNetworks < ActiveRecord::Migration
  def change
    rename_column :programs, :network, :network_name

    add_column :programs, :network_id, :integer
    add_index :programs, :network_id

    create_table :networks do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
