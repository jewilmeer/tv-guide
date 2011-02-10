require 'spec_helper'
require 'factory_girl_rails'

describe Program do
  let(:program) { FactoryGirl.create(:program) }
  
  it "should validate the object" do
    simple_model = Program.new
    simple_model.should_not be_valid
    
    valid_model = FactoryGirl.build(:program)
    valid_mode.should be_valid
  end
  
  it 'Should fill the name of the program as default search term' do
    program.name.should == program.search_term
  end
end
