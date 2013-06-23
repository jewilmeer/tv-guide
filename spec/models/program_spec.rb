require 'spec_helper'

describe Program do
  describe "#update name" do
    let(:episode) { create :episode, program: program }
    let(:program) { create(:program) }

    it "also updates the program name of associated episodes" do
      expect{ program.update_attribute(:name, 'changed') }.to \
        change(episode, :program_name)
    end

    it "does not update the episode if the name is unchanged" do
      expect{ program.update_attribute(:max_season_nr, 99) }.not_to \
        change(episode, :program_name)
    end
  end
end
