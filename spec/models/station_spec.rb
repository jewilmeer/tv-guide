require 'spec_helper'

describe Station do
  context "scopes" do
    describe "filled" do
      let(:user1) { create :user }
      let(:user2) { create :user }
      let(:user3) { create :user }
      let(:programs) { create_list :program, 3 }
      let(:user_station1) { user1.stations.personal.first }
      let(:user_station2) { user2.stations.personal.first }
      let(:user_station3) { user3.stations.personal.first }

      before do
        user_station1.programs << programs.first << programs.last
        user_station2.programs << programs.first
      end

      it "shows only stations with program in it" do
        expect(Station.filled).to include(user_station1, user_station2)
      end
      it "does only include a station once" do
        expect(Station.filled.size).to eq(2)
      end
      it "doesn't return empty stations" do
        expect(Station.filled).not_to include(user_station3)
      end
    end
  end
end