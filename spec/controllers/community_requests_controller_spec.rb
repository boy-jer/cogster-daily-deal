require 'spec_helper'

describe CommunityRequestsController do

  let(:community_request) { mock_model(CommunityRequest) }

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end

  describe "POST 'create'" do
    before :each do
      CommunityRequest.stub(:new).with('the' => 'params') { community_request }
    end

    context "success" do
      before :each do
        controller.should_receive(:verify_recaptcha).and_return(true)
        community_request.should_receive(:save).and_return(true)
        post :create, :community_request => { 'the' => 'params' }
      end
    
      it "redirects to root path" do
        response.should redirect_to(root_path)
      end

      it "provides notice of new request" do
        flash[:notice].should == "Thanks! We'll get right on that"
      end
    end

    context "failure due to community request" do
      before :each do
        controller.should_receive(:verify_recaptcha).and_return(true) 
        community_request.should_receive(:save).and_return(false)
        post :create, :community_request => { 'the' => 'params' }
      end

      it "assigns @community_request" do
        assigns(:community_request).should == community_request
      end

      it "renders new" do
        response.should render_template(:new)
      end
    
    end

    context "failure due to recaptcha" do
    
      before :each do
        controller.should_receive(:verify_recaptcha).and_return false
        post :create, :community_request => { 'the' => 'params' }
      end
    
      it "assigns @community_request" do
        assigns(:community_request).should == community_request
      end

      it "renders new" do
        response.should render_template(:new)
      end
    end
  end


end

