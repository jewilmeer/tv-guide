class Image < ActiveRecord::Base
  has_attached_file :image, :styles => { :banner => "642x100>", :thumb => "100x100>" }
end