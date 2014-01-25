class AddKeys < ActiveRecord::Migration
  def change
    add_foreign_key "programs", "networks", name: "programs_network_id_fk"
  end
end
