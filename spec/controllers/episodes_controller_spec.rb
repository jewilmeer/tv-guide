require 'spec_helper'

describe EpisodesController, type: :controller do
  describe "show" do
    let(:episode) { create :episode }
    let(:show_request) { get :show, id: episode.id, program_id: episode.program_id }

    before { show_request }
    it { expect(response).to have_http_status :success }
  end

  describe "update" do
    let(:episode) { create :episode }
    let(:request) { put :update, id: episode.id, program_id: 2, format: :js }

    context "not logged in" do
      before { request }
      it { expect(response).to have_http_status :unauthorized }
    end

    context "logged in" do
      before do
        sign_in create(:user)
        allow_any_instance_of(Episode).to receive(:ensure_up_to_date) { true }
        allow_any_instance_of(Episode).to receive(:download) { true }
        request
      end

      it { expect(response).to have_http_status :success }
    end
  end
end