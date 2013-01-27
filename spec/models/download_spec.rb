# == Schema Information
#
# Table name: downloads
#
#  id                    :integer          not null, primary key
#  episode_id            :integer
#  download_type         :string(255)
#  download_file_name    :string(255)
#  download_content_type :string(255)
#  download_file_size    :integer
#  origin                :string(255)
#  site                  :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#

require 'spec_helper'

describe Download do
  subject { create :download }

  it "should update the associated episode" do
    subject.episode.should_receive(:touch)
    subject.save
  end
end
