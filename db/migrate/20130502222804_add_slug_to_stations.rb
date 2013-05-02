class AddSlugToStations < ActiveRecord::Migration
  def change
    add_column :stations, :slug, :string
    add_index :stations, :slug
  end
end
