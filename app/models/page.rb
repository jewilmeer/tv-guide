class Page < ActiveRecord::Base
  def to_param
    permalink.parameterize
  end
end

# == Schema Information
#
# Table name: pages
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  permalink  :string(255)
#  content    :text
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

