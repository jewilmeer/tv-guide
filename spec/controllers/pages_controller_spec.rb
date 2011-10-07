require 'spec_helper'

describe PagesController do
  context "#index" do
    before { get :index }
    it { should respond_with :success }
  end
end