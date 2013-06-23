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
