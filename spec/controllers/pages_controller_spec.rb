require 'spec_helper'

describe PagesController, type: :controller do
  describe "#index" do
    before { get :index }
    it { expect(response).to have_http_status(:redirect) }

    context "Not logged in" do
      it { expect(response).to redirect_to guide_programs_path }
    end
  end
end