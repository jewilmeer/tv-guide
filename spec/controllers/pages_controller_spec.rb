require 'spec_helper'
require 'authlogic/test_case'

describe PagesController do
  describe "#index" do
    before { get :index }
    it { should respond_with :redirect }
    
    context "logged in" do
      let(:user) { create :user }
      before do
        include Authlogic::TestCase
        activate_authlogic
        UserSession.create( user )
      end
      its(:current_user) { should eql user }
      it { should redirect_to user_programs_path(current_user)}
    end

    context "Not logged in" do
      it { should redirect_to guide_programs_path }
    end
  end
end