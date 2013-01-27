class DatabaseCleanup < ActiveRecord::Migration
  def up
    drop_table :active_admin_comments
    drop_table :admin_users
    drop_table :admins
    drop_table :authentications
    drop_table :posts
    drop_table :program_updates
    drop_table :seasons
  end

  def down
    #no we do not want this back
  end
end
