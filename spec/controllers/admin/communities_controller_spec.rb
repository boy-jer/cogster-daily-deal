require 'spec_helper'

describe Admin::CommunitiesController do
  include Devise::TestHelpers

  let(:community) { mock_model(Community) }

  before :each do
    sign_in_as_admin
  end

  def stub_find
    Community.stub(:find).with(:id) { community }
  end

  describe "POST 'create'" do
    before :each do
      Community.stub(:new).with('the' => 'params') { community }
    end

    context "success" do
      before :each do
        community.should_receive(:save).and_return(true)
        community.should_receive(:name).and_return('x')
        post :create, :community => { 'the' => 'params' }
      end
    
      it "redirects to communities path" do
        response.should redirect_to(admin_communities_path)
      end

      it "provides notice of new community" do
        flash[:notice].should == "The community of 'x' has been added" 
      end
    end

    context "failure" do
      before :each do
        community.should_receive(:save).and_return(false)
        post :create, :community => { 'the' => 'params' }
      end

      it "assigns @community" do
        assigns(:community).should == community
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
        community.should_receive(:destroy)
        community.should_receive(:name).and_return('x')
        delete :destroy, :id => :id
      end

      it "redirects to communities path" do
        response.should redirect_to(admin_communities_path)
      end

      it "provides notice of deletion" do
        flash[:notice].should == "The community of 'x' has been deleted"
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

  describe "PUT 'update'" do
    before :each do
      stub_find
    end

    context "success" do
      before :each do
        community.should_receive(:update_attributes).and_return true
        put :update, :id => :id, :community => {}
      end
    
      it "redirects to communities path" do
        response.should redirect_to(admin_communities_path)
      end

      it "provides notice of update" do
        flash[:notice].should == "Community updated"
      end
    end

    context "failure" do
    
      before :each do
        community.should_receive(:update_attributes).and_return false
        put :update, :id => :id, :community => {}
      end
    
      it "renders the edit form" do
        response.should render_template(:edit)
      end
    end
  end
end
