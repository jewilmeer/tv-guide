class AddSlugAndFirstAiredToPrograms < ActiveRecord::Migration
  def up
    add_column :programs, :first_aired, :datetime
    add_column :programs, :slug, :string

    add_index :programs, :slug
  end

  def down
    remove_index :programs, :slug

    remove_column :programs, :slug
    remove_column :programs, :first_aired
  end
end
