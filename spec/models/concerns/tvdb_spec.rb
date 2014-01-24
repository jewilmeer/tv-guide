require 'spec_helper'
describe Concerns::TVDB do

  describe 'tvdb_updated_tvdb_ids' do
    let(:update_result) do
      {
        "Time"  => "1372283106",
        "Series"=> ["1", "2", "3"]
      }
    end

    before do
      Program.stub_chain(:tvdb_client, :get_series_updates).and_return(update_result)
    end

    it "returns a list of arrays if there are updates" do
      expect( Program.tvdb_updated_tvdb_ids(5.minutes.ago) ).to eql [1,2,3]
    end

    context "with empty resultset" do
      let(:update_result) { { "Time"  => "1372283106" } }

      it "it returns an empty array" do
        expect( Program.tvdb_updated_tvdb_ids(5.minutes.ago) ).to eql []
      end
    end
  end

  describe "tvdb_serie!" do
    let(:program) { Program.new(tvdb_id: 1234) }

    it "return result if there is a result" do
      program.stub(tvdb_serie: true)
      expect{ program.tvdb_serie! }.to be_true
    end

    it "raises an error upon nil" do
      program.stub(tvdb_serie: nil)
      expect{ program.tvdb_serie! }.to raise_error TVDBNotFound
    end
  end

  describe "valid format" do
    subject { Program.new }
    it { should allow_value('House of pain').for(:name) }
    it { should_not allow_value('***DUPLICATE').for(:name) }
  end
end