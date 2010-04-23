require 'spec_helper'

describe "admin_programs/index.html.haml" do
  before(:each) do
    assign(:admin_programs, [
      stub_model(Admin::Program),
      stub_model(Admin::Program)
    ])
  end

  it "renders a list of admin_programs" do
    render
  end
end
