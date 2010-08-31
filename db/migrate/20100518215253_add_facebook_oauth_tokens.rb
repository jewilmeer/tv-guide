class AddFacebookOauthTokens < ActiveRecord::Migration
  def self.up
    add_column :users, :oauth_uid, :string
  end

  def self.down
  end
end
