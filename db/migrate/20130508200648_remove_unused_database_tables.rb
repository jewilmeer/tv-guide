class RemoveUnusedDatabaseTables < ActiveRecord::Migration
  def up
    drop_table :configurations
    drop_table :episodes_users
    drop_table :images
    drop_table :images_programs
    drop_table :pages

    remove_index :programs_users, name: 'index_programs_users_on_program_id_and_user_id'
    remove_index :programs_users, name: 'index_programs_users_on_user_id_and_program_id'

    drop_table :programs_users
    drop_table :search_term_types
  end
end
