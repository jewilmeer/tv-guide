ActiveAdmin.register Image do
  index :as => :grid, :limit => 5, :columns => 5 do |image|
    image_tag image.s3_url(:thumb)
  end
  
  form do |f|
    f.inputs "Image details" do
      f.input :image_type, :as => :select, :collection => Image.group('image_type').map(&:image_type).map(&:to_sym)
      f.input :image, :as => :file
      f.input :programs

      f.buttons
    end
  end
end
