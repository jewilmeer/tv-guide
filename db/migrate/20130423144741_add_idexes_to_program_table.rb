class AddIdexesToProgramTable < ActiveRecord::Migration
  def change
    add_index :programs, :tvdb_id
  end
end
