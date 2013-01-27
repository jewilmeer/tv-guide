# == Schema Information
#
# Table name: images
#
#  id                 :integer          not null, primary key
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  created_at         :datetime
#  updated_at         :datetime
#  url                :string(255)
#  image_type         :string(255)
#  downloaded         :boolean          default(FALSE)
#

require 'spec_helper'

describe Image do
  
  context "episoce image" do
    subject { create :episode_image }

    it "should also update the associated episode" do
      subject.episode.should_receive(:touch)
      subject.save
    end
  end

  context "program image" do
    subject { create :image }

    it "should try to update the connected episode" do
      Episode.any_instance.should_not_receive(:touch)
      subject.save
    end
  end
end
