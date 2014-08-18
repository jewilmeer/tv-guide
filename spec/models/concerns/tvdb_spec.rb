require 'spec_helper'
describe Concerns::TVDB do
  let(:klass) do
    class Dummy
      extend ActiveModel::Callbacks
      define_model_callbacks :create
      include ActiveModel::Validations
      include Concerns::TVDB
    end
  end
  let(:instance) { klass.new }

  describe 'tvdb_updated_tvdb_ids' do
    let(:update_result) do
      {
        "Time"  => "1372283106",
        "Series"=> ["1", "2", "3"]
      }
    end

    before do
      allow(Program).to receive_message_chain(:tvdb_client, :get_series_updates) { update_result }
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
      allow(program).to receive(:tvdb_serie) { true }
      expect(program.tvdb_serie!).to be_truthy
    end

    it "raises an error upon nil" do
      allow(program).to receive(:tvdb_serie) { nil }
      expect{ program.tvdb_serie! }.to raise_error TVDBNotFound
    end
  end

  describe "valid format" do
    let(:program) { Program.new }
    it "allows valid names" do
      program.name = 'House of pain'
      expect(program.valid?).to be_truthy
    end

    it "disallows invalid names" do
      program.name = '***DUPLICATE'
      expect(program.valid?).not_to be_truthy
    end
  end

  describe "tvdb_updated_within?" do
    def tvdb_updated_within?(timestamp)
      instance.tvdb_updated_within?(timestamp)
    end
    let(:last_checked_at) { 1.month.ago }

    before { allow(instance).to receive(:last_checked_at) { last_checked_at} }

    describe "within given range" do
      it 'is true' do
        expect( tvdb_updated_within?(2.months) ).to be_truthy
      end
    end

    describe "outside given range" do
      it "it true" do
        expect( tvdb_updated_within?(1.day) ).to be_falsey
      end
    end
  end

  describe "needs_tvdb_update?" do
    subject { instance.needs_tvdb_update? }
    let(:last_checked_at) { nil }
    let(:active) { false }

    before do
      allow(instance).to receive(:last_checked_at) { last_checked_at }
      allow(instance).to receive(:active) { active }
    end

    it "is true by default" do
      expect(subject).to be_truthy
    end

    describe "3 weeks not checked" do
      let(:last_checked_at) { 3.weeks.ago }

      it "doesn't need an update" do
        expect(subject).to be_falsey
      end
    end

    describe "1 month not checked" do
      let(:last_checked_at) { 1.month.ago }

      it "it needs an update" do
        expect(subject).to be_truthy
      end
    end

    describe "active, 1 day not checked" do
      let(:active) { true }
      let(:last_checked_at) { 25.hours.ago }
      it "needs an update" do
        expect(subject).to be_truthy
      end
    end

    describe "active, 1 hour not checked" do
      let(:active) { true }
      let(:last_checked_at) { 1.hours.ago }
      it "needs an update" do
        expect(subject).to be_falsey
      end
    end
  end
end