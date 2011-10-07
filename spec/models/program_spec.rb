require 'spec_helper'
require 'factory_girl_rails'

describe Program do
  subject { build(:program, {:fetch_remote_information => false}) }
  
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
end
