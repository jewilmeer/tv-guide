require 'spec_helper'

describe "admin_users/edit.html.haml" do
  before(:each) do
    assign(:user, @user = stub_model(Admin::User,
      :new_record? => false
    ))
  end

  it "renders the edit user form" do
    render

    response.should have_selector("form", :action => user_path(@user), :method => "post") do |form|
    end
  end
end
