# == Schema Information
# Schema version: 20101130174533
#
# Table name: pages
#
#  id         :integer(4)      not null, primary key
#  title      :string(255)
#  permalink  :string(255)
#  content    :text
#  user_id    :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class Page < ActiveRecord::Base
  def to_param
    permalink.parameterize
  end
end
