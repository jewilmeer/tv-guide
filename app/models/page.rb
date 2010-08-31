class Page < ActiveRecord::Base
  def to_param
    permalink.parameterize
  end
end
