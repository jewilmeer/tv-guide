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