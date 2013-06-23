require 'spec_helper'

describe Episode do
  describe 'associations' do
    it { should belong_to(:program) }
    it { should have_many(:interactions) }
    it { should have_many(:downloads) }
  end

  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :season_nr }
    it { should validate_presence_of :program_id }
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

  describe "interpolated_search_term" do
    subject { episode.interpolated_search_term }
    let(:episode) { build_stubbed :episode, nr: 2, season_nr: 1 }

    before do
      episode.stub(:search_term_pattern => search_term_pattern)
      episode.stub_chain(:program, :search_name).and_return("TestName")
    end

    context "default interpolation" do
      let(:search_term_pattern) { "%{program_name} S%{season_nr}E%{episode_nr}" }
      it { should eql "TestName S1E2" }
    end

    context "alternative interpolation" do
      let(:search_term_pattern) { "%{program_name} S%{season_nr}x%{episode_nr}" }
      it { should eql "TestName S1x2" }
    end

    context "interpolation with filled values" do
      let(:search_term_pattern) { "%{program_name} S%{filled_season_nr}E%{filled_episode_nr}" }
      it { should eql "TestName S01E02" }
    end
  end
end
