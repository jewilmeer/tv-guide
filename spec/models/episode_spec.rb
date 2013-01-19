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

  describe "interpolated_search_term" do
    subject { episode.interpolated_search_term }
    let(:episode) { create :episode, nr: 2, season_nr: 1 }
    before {
      episode.stub(:search_term_pattern => search_term_pattern)
      episode.stub_chain(:program, :search_name).and_return("TestName")
    }

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

  describe "search_term_pattern" do
    subject { episode.search_term_pattern }
    let(:episode) { create :episode, name: 'TestName', nr: 2, season_nr: 1 }
    let(:configuration) { create :configuration }

    before do
      episode.stub(:active_configuration => configuration)
      configuration.stub(:search_term_pattern => "lorem")
    end

    it { should eql "lorem" }
  end

  describe "to_be_donwloaded" do
    subject { Episode.airs_at_inside(1.week.ago, 1.week.from_now).to_be_downloaded }
    let!(:episodes_with_download_outside_range) { create_list :episode, 2, :with_download, airs_at: 2.months.ago }
    let!(:episodes_with_download) { create_list :episode, 2, :with_download }
    let!(:episodes_without_download) { create_list :episode, 2 }

    it "retunrs episodes without downloads" do
      expect(subject.to_a).to eql episodes_without_download
    end

    its(:count) { should be 2 }
  end
end
