require 'spec_helper'

describe PagesController do
  describe "#index" do
    before { get :index }
    it { should respond_with :redirect }

    context "Not logged in" do
      it { should redirect_to guide_programs_path }
    end
  end
end