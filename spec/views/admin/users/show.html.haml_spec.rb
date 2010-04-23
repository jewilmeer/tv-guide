require 'spec_helper'

describe "admin_users/show.html.haml" do
  before(:each) do
    assign(:user, @user = stub_model(Admin::User)
  end

  it "renders attributes in <p>" do
    render
  end
end
