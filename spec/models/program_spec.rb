require 'spec_helper'
require 'factory_girl_rails'

describe Program do
  let(:program) { create(:program, {:fetch_remote_information => false}) }
  subject { program }
  
  it { should be_valid }

  describe '#fetch_remote_information' do
    it 'should be true if not set' do
      subject.fetch_remote_information=nil
      subject.fetch_remote_information.should be_true
    end

    it 'should be true if set so' do
      subject.fetch_remote_information=true
      subject.fetch_remote_information.should be_true
    end
    it 'should be false if set so' do
      subject.fetch_remote_information=false
      subject.fetch_remote_information.should be_false
    end
  end

  describe "#update name" do
    before do
      5.times do |i|
        create :episode, :name => "title #{i}", :program_id => program.id, :program_name => 'bla'
      end
    end
    let(:episode) { program.episodes.find(:first) }

    context "with name update" do
      before do
        program.name = program.name + "changed"
      end

      it "should also update the program name of associated episodes" do
        program.save
        program.name.should eql episode.program_name
      end
    end

    context "without name update" do
      before do
        subject.attributes = {
          :overview => "lorem ipsum ander dingetje"
        }
      end
      it "#should not update attached episodes" do
        expect { subject.save }.not_to change episode, :updated_at
      end
    end
  end
end
