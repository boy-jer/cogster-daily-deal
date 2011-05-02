require 'spec_helper'

describe Admin::BusinessesController do

  let(:business) { mock_model(Business, :name => 'bj') }

  before :each do
    sign_in_as_admin
  end

  def stub_find
    Business.stub(:find).with(:id) { business }
  end

  describe "POST 'create'" do
    before :each do                              
      @merchant = User.new 
      User.stub(:new).with('the' => 'params') { @merchant }
    end

    context "success" do
      before :each do
        @merchant.should_receive(:save).and_return(true)
        @merchant.should_receive(:business) { business }
        post :create, :user => { 'the' => 'params' }
      end
    
      it "redirects to businesses path" do
        response.should redirect_to(admin_businesses_path)
      end

      it "provides notice of new business" do
        flash[:notice].should == "bj has been created"
      end
    end

    context "failure" do
      before :each do
        @merchant.should_receive(:save).and_return(false)
        post :create, :user => { 'the' => 'params' }
      end

      it "assigns @merchant" do
        assigns(:merchant).should == @merchant
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
        business.should_receive(:destroy)
        business.should_receive(:name).and_return('x')
        delete :destroy, :id => :id
      end

      it "redirects to businesses path" do
        response.should redirect_to(admin_businesses_path)
      end

      it "provides notice of deletion" do
        flash[:notice].should == "x has been deleted"
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
      get :new
      response.should be_success 
    end
  end

  describe "GET 'show'" do
    before :each do
      Business.stub_chain(:includes, :find) { business }
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
        business.should_receive(:update_attributes).and_return true
        put :update, :id => :id, :business => {}
      end
    
      it "redirects to business path" do
        response.should redirect_to(admin_businesses_path)
      end

      it "provides notice of update" do
        flash[:notice].should == "Business updated"
      end
    end

    context "failure" do
    
      before :each do
        business.should_receive(:update_attributes).and_return false
        put :update, :id => :id, :business => {}
      end
    
      it "renders the edit form" do
        response.should render_template(:edit)
      end
    end
  end
end
