class SetPasswordSaltToAllowNil < ActiveRecord::Migration
  def up
    change_column :users, :password_salt, :string, null: true
  end

  def down
  end
end
