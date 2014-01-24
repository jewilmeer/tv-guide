class AddActiveGenreFlag < ActiveRecord::Migration
  def change
    add_column :genres, :active, :boolean, default: true

    Genre.reset_column_information
    Genre.update_all(active: true)
  end
end
