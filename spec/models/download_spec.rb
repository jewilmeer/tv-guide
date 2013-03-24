require 'spec_helper'

describe Download do
  let!(:episode) { create :episode }
  let(:download) { build :download, episode: episode }

  it "updates the episode upon creation" do
    expect { download.save }.to change episode, :updated_at
  end
end

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

