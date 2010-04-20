class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string :title
      t.text :content
      t.boolean :online, :default => false
      t.integer :user_id
    end
  end

  def self.down
    drop_table :pages
  end
end
