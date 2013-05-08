class RemoveUnusedAttributes < ActiveRecord::Migration
  def up
    change_table :episodes do |t|
      t.remove :path, :downloaded, :watched
      t.remove :season_id, :nzb_file_name, :nzb_content_type
      t.remove :nzb_file_size, :nzb_updated_at, :downloads
      t.remove :tvdb_program_id, :image_id
    end

    drop_table :program_preferences

    change_table :programs do |t|
      t.remove :tvdb_last_update, :fanart_image_id
      t.remove :poster_image_id, :season_image_id, :series_image_id
      t.remove :interactions_count
    end
  end

  def down
  end
end
