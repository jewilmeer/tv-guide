class AddImageTable < ActiveRecord::Migration
  def up
    create_table :images do |t|
      t.string :file
      t.string :source_url
      t.string :image_type
      t.boolean :downloaded, default: false

      t.references :program

      t.timestamps
    end
  end

  def down
    drop_table :images
  end
end
