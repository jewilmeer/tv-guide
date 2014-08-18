require 'spec_helper'

describe Episode do
  describe "valid_season_or_episode_nr" do
    subject { Episode.valid_season_or_episode_nr number }

    context "0" do
      let(:number) { 0 }
      it { expect(subject).to be(false) }
    end
    context "1" do
      let(:number) { 1 }
      it { expect(subject).to be(true) }
    end
    context "2" do
      let(:number) { 2 }
      it { expect(subject).to be(true) }
    end
    context "99" do
      let(:number) { 99 }
      it { expect(subject).to be(false) }
    end
  end

  describe "interpolated_search_term" do
    subject { episode.interpolated_search_term }
    let(:episode) { Episode.new nr: 2, season_nr: 1 }

    before do
      allow(episode).to receive(:search_term_pattern) { search_term_pattern }
      allow(episode).to receive_message_chain(:program, :search_name) { "TestName" }
    end

    context "default interpolation" do
      let(:search_term_pattern) { "%{program_name} S%{season_nr}E%{episode_nr}" }
      it { expect(subject).to eql "TestName S1E2" }
    end

    context "alternative interpolation" do
      let(:search_term_pattern) { "%{program_name} S%{season_nr}x%{episode_nr}" }
      it { expect(subject).to eql "TestName S1x2" }
    end

    context "interpolation with filled values" do
      let(:search_term_pattern) { "%{program_name} S%{filled_season_nr}E%{filled_episode_nr}" }
      it { expect(subject).to eql "TestName S01E02" }
    end
  end
end
