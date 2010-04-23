require 'spec_helper'

describe Admin::ProgramsController do

  def mock_program(stubs={})
    @mock_program ||= mock_model(Admin::Program, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all admin_programs as @admin_programs" do
      Admin::Program.stub(:all) { [mock_program] }
      get :index
      assigns(:admin_programs).should eq([mock_program])
    end
  end

  describe "GET show" do
    it "assigns the requested program as @program" do
      Admin::Program.stub(:find).with("37") { mock_program }
      get :show, :id => "37"
      assigns(:program).should be(mock_program)
    end
  end

  describe "GET new" do
    it "assigns a new program as @program" do
      Admin::Program.stub(:new) { mock_program }
      get :new
      assigns(:program).should be(mock_program)
    end
  end

  describe "GET edit" do
    it "assigns the requested program as @program" do
      Admin::Program.stub(:find).with("37") { mock_program }
      get :edit, :id => "37"
      assigns(:program).should be(mock_program)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created program as @program" do
        Admin::Program.stub(:new).with({'these' => 'params'}) { mock_program(:save => true) }
        post :create, :program => {'these' => 'params'}
        assigns(:program).should be(mock_program)
      end

      it "redirects to the created program" do
        Admin::Program.stub(:new) { mock_program(:save => true) }
        post :create, :program => {}
        response.should redirect_to(admin_program_url(mock_program))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved program as @program" do
        Admin::Program.stub(:new).with({'these' => 'params'}) { mock_program(:save => false) }
        post :create, :program => {'these' => 'params'}
        assigns(:program).should be(mock_program)
      end

      it "re-renders the 'new' template" do
        Admin::Program.stub(:new) { mock_program(:save => false) }
        post :create, :program => {}
        response.should render_template(:new)
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested program" do
        Admin::Program.should_receive(:find).with("37") { mock_program }
        mock_program.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :program => {'these' => 'params'}
      end

      it "assigns the requested program as @program" do
        Admin::Program.stub(:find) { mock_program(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:program).should be(mock_program)
      end

      it "redirects to the program" do
        Admin::Program.stub(:find) { mock_program(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(admin_program_url(mock_program))
      end
    end

    describe "with invalid params" do
      it "assigns the program as @program" do
        Admin::Program.stub(:find) { mock_program(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:program).should be(mock_program)
      end

      it "re-renders the 'edit' template" do
        Admin::Program.stub(:find) { mock_program(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template(:edit)
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested program" do
      Admin::Program.should_receive(:find).with("37") { mock_program }
      mock_program.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the admin_programs list" do
      Admin::Program.stub(:find) { mock_program(:destroy => true) }
      delete :destroy, :id => "1"
      response.should redirect_to(admin_programs_url)
    end
  end

end
