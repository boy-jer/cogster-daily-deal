require 'spec_helper'

describe ProjectOptionsController do
  include Devise::TestHelpers

  let(:project_option) { mock_model(ProjectOption) }

  before :each do
    sign_in_as_admin
  end

  def stub_find
    ProjectOption.stub(:find).with(:id) { project_option }
  end

  describe "POST 'create'" do
    before :each do
      ProjectOption.stub(:new).with('the' => 'params') { project_option }
    end

    context "success" do
      before :each do
        project_option.should_receive(:save).and_return(true)
        post :create, :project_option => { 'the' => 'params' }
      end
    
      it "redirects to project_options path" do
        response.should redirect_to(admin_project_options_path)
      end

      it "provides notice of new project option" do
        flash[:notice].should == "New project option has been created"
      end
    end

    context "failure" do
      before :each do
        project_option.should_receive(:save).and_return(false)
        post :create, :project_option => { 'the' => 'params' }
      end

      it "assigns @project_option" do
        assigns(:project_option).should == project_option
      end

      it "renders new" do
        response.should render_template(:new)
      end
    
    end
  end

  describe "DELETE 'destroy'" do
    before :each do
      stub_find
    end

    context "success" do
      before :each do
        project_option.should_receive(:destroy)
        project_option.should_receive(:description).and_return('x')
        delete :destroy, :id => :id
      end

      it "redirects to project_options path" do
        response.should redirect_to(admin_project_options_path)
      end

      it "provides notice of deletion" do
        flash[:notice].should == "The project option 'x' has been deleted"
      end
    end

  end

  describe "GET 'edit'" do
    before :each do
      stub_find
      get :edit, :id => :id
    end

    it "shows the page" do
      response.should be_success 
    end
  end

  describe "GET 'index'" do
    it "shows the page" do
      get :index
      response.should be_success 
    end
  end

  describe "GET 'new'" do
    it "shows the page" do
      get :index
      response.should be_success 
    end
  end

  describe "GET 'show'" do
    before :each do
      ProjectOption.stub_chain(:includes, :find) { project_option }
      get :show, :id => :id
    end

    it "shows the page" do
      response.should be_success 
    end
  end

  describe "PUT 'update'" do
    before :each do
      stub_find
    end

    context "success" do
      before :each do
        project_option.should_receive(:update_attributes).and_return true
        put :update, :id => :id, :project_option => {}
      end
    
      it "redirects to project_options path" do
        response.should redirect_to(admin_project_options_path)
      end

      it "provides notice of update" do
        flash[:notice].should == "Project option updated"
      end
    end

    context "failure" do
    
      before :each do
        project_option.should_receive(:update_attributes).and_return false
        put :update, :id => :id, :project_option => {}
      end
    
      it "renders the edit form" do
        response.should render_template(:edit)
      end
    end
  end
end
