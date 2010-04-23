require 'spec_helper'

describe "admin_users/new.html.haml" do
  before(:each) do
    assign(:user, stub_model(Admin::User,
      :new_record? => true
    ))
  end

  it "renders new user form" do
    render

    response.should have_selector("form", :action => admin_users_path, :method => "post") do |form|
    end
  end
end
