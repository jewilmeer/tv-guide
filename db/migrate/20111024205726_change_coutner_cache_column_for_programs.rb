class ChangeCoutnerCacheColumnForPrograms < ActiveRecord::Migration
  def up
    rename_column :programs, :users_count, :program_preferences_count
  end

  def down
    rename_column :programs, :program_preferences_count, :users_count
  end
end
