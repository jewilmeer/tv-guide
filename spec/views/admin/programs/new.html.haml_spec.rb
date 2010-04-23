require 'spec_helper'

describe "admin_programs/new.html.haml" do
  before(:each) do
    assign(:program, stub_model(Admin::Program,
      :new_record? => true
    ))
  end

  it "renders new program form" do
    render

    response.should have_selector("form", :action => admin_programs_path, :method => "post") do |form|
    end
  end
end
