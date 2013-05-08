FactoryGirl.define do
  factory :download do
    origin "Fancy download"
    site "google.com"
    download_file_name "download.nzb"
    download_type 'hd'
    # associations
    # episode
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

