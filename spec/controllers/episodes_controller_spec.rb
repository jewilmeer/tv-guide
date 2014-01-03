require 'spec_helper'

describe EpisodesController do
  describe "show" do
    let(:episode) { create :episode }
    let(:show_request) { get :show, id: episode.id, program_id: 2 }

    before { show_request }
    it { should respond_with :success }
  end

  describe "update" do
    let(:episode) { create :episode }
    let(:request) { put :update, id: episode.id, program_id: 2, format: :js }

    context "not logged in" do
      before { request }
      it { should respond_with :unauthorized }
    end

    context "logged in" do
      before do
        sign_in create(:user)
        Episode.any_instance.stub(ensure_up_to_date: true)
        Episode.any_instance.stub(download: true)
        request
      end

      it { should respond_with :success }
    end
  end
end