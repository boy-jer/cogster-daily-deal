require 'spec_helper'

describe CommunitiesController do
  let(:business) { Business.new }
  let(:community) { mock_model(Community, :businesses => [business], :users => [User.new]) }

  describe "GET 'show'" do
    before :each do
      Community.stub(:all) { [community, :other_community] }
      Community.stub_chain('includes.find') { community }
      get :show, :id => :id
    end

    it "shows the page" do
      response.should be_success 
    end

    it "assigns @businesses" do
      assigns(:businesses).should == [business]
    end
  
    it "assigns @communities" do
      assigns(:communities).should == [:other_community]
    end
  end
    
end
