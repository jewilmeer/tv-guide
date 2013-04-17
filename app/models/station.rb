class Station < ActiveRecord::Base
  belongs_to :user
  belongs_to :taggable, polymorphic: true

  validates :name, presence: true
end

# == Schema Information
#
# Table name: stations
#
#  id            :integer          not null, primary key
#  name          :string(255)      not null
#  user_id       :integer
#  taggable_id   :integer
#  taggable_type :string(255)
#