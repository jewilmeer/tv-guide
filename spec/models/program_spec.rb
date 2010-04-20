require 'spec_helper'

describe Program do
  
  it "should validate the object" do
    simple_model = Factory(:program)
    simple_model.should_not be_valid?
    
    valid_model = Factory(:program, :name => 'test programname')
    valid_mode.should be_valid?
  end
end
