require 'spec_helper'

describe "admin_programs/show.html.haml" do
  before(:each) do
    assign(:program, @program = stub_model(Admin::Program)
  end

  it "renders attributes in <p>" do
    render
  end
end
