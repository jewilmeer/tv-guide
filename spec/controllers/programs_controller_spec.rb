require 'spec_helper'

describe ProgramsController do
  # subject { controller }
  context 'not logged in' do
    describe 'GET index' do
      before { get :index }
      it { should respond_with :success }
      it { should assign_to :programs }
    end

    describe 'GET show' do
      before do 
        @program = create(:program, :name => 'My tv show')
        get :show, :id => @program.to_param
      end

      it { should respond_with :success }
      it { should assign_to :program }
    end
  end


end