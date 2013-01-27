class AuthlogicToDevise < ActiveRecord::Migration
  def self.up
    rename_column :users, :crypted_password, :encrypted_password

    add_column :users, :reset_password_token, :string, :limit => 255

    add_column :users, :remember_token, :string, :limit => 255
    add_column :users, :remember_created_at, :timestamp
    rename_column :users, :login_count, :sign_in_count
    rename_column :users, :current_login_at, :current_sign_in_at
    rename_column :users, :last_login_at, :last_sign_in_at
    rename_column :users, :current_login_ip, :current_sign_in_ip

    rename_column :users, :failed_login_count, :failed_attempts
    rename_column :users, :single_access_token, :authentication_token

    remove_column :users, :persistence_token
    remove_column :users, :perishable_token

    add_index :users, :reset_password_token, :unique => true
  end

  def self.down
    rename_column :users, :encrypted_password, :crypted_password

    remove_index :users, :reset_password_token

    add_column :users, :persistence_token, :string
    add_column :users, :perishable_token, :string

    rename_column :users, :failed_attempts, :failed_login_count

    remove_column :users, :remember_token
    remove_column :users, :remember_created_at
    rename_column :users, :sign_in_count, :login_count
    rename_column :users, :current_sign_in_at, :current_login_at
    rename_column :users, :last_sign_in_at, :last_login_at
    rename_column :users, :current_sign_in_ip, :current_login_ip
    rename_column :users, :last_sign_in_ip, :last_login_ip


    remove_column :users, :reset_password_token
  end
end
