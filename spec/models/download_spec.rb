require 'spec_helper'

describe Download do
  subject { create :download }

  it "should update the associated episode" do
    subject.episode.should_receive(:touch)
    subject.save
  end
end