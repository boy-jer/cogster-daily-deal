require 'spec_helper'

describe ProjectsController do

  before :each do
    sign_in_as_admin
    @business = Business.new 
    Business.stub(:find) { @business }
  end

  describe "POST 'create'" do
    before :each do
      @project = Project.new
      @business.projects.stub(:new) { @project }
    end

    describe "success" do
      before :each do
        @business.stub(:to_param) { '1-bjs' }
        @project.stub(:save).and_return true
      end

      it "redirects" do
        post :create, :business_id => :business_id, :project => { :valid => :params }
        response.should be_redirect
      end

      it "sets project to active" do
        post :create, :business_id => :business_id, :project => { :valid => :params }
        assigns(:project).should be_active
      end

      it "redirects admin to business page" do
        post :create, :business_id => :business_id, :project => { :valid => :params }
        response.should redirect_to(admin_business_path(@business))
      end

      it "redirects merchant to account page" do
        controller.stub(:current_user) { mock_model(User, :merchant? => true)}
        post :create, :business_id => :business_id, :project => { :valid => :params }
        response.should redirect_to(account_path)
      end
    end

    describe "failure" do
      before :each do
        @project.stub(:save).and_return false
        post :create, :business_id => :business_id, :project => { :invalid => :params }
      end

      it "renders the form" do
        response.should render_template('new')
      end
    end
  end
end
