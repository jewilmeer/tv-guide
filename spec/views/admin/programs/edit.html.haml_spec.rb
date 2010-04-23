require 'spec_helper'

describe "admin_programs/edit.html.haml" do
  before(:each) do
    assign(:program, @program = stub_model(Admin::Program,
      :new_record? => false
    ))
  end

  it "renders the edit program form" do
    render

    response.should have_selector("form", :action => program_path(@program), :method => "post") do |form|
    end
  end
end
