require 'spec_helper'

describe EpisodesController do
  describe "show" do
    let(:episode) { create :episode }
    let(:request) { get :show, id: episode.id }

    before { request }
    it { should assign_to :episode }
    it { should respond_with :success }
  end

  describe "update" do
    let(:episode) { create :episode }
    let(:request) { put :update, id: episode.id, format: :js }

    context "not logged in" do
      before { request }
      it { should respond_with :unauthorized }
    end

    context "logged in" do
      before do
        sign_in create(:user)
        Episode.any_instance.stub(ensure_up_to_date: true)
        request
      end

      it { should respond_with :success }
    end
  end
end