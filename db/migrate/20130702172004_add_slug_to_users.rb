class AddSlugToUsers < ActiveRecord::Migration
  def change
    add_column :users, :slug, :string

    User.find_each(&:save)
  end
end
