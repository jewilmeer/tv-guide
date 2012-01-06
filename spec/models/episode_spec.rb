require 'spec_helper'

describe Episode do
  subject { create(:episode) }
  context "creation" do
    it { should be_valid }
  end

  describe 'associations' do
    it { should belong_to(:program) }
    it { should belong_to(:image) }
    it { should have_many(:interactions) }
    it { should have_many(:downloads) }
  end

  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :season_nr }
    it { should validate_presence_of :program_id }
    it { should validate_presence_of :nr }
  end

  describe "valid_season_or_episode_nr" do
    subject { Episode.valid_season_or_episode_nr number }

    context "0" do
      let(:number) { 0 }
      it { should be_false }
    end
    context "1" do
      let(:number) { 1 }
      it { should be_true }
    end
    context "2" do
      let(:number) { 2 }
      it { should be_true }
    end
    context "99" do
      let(:number) { 99 }
      it { should be_false }
    end
  end
end
