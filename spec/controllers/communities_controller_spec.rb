require 'spec_helper'

describe CommunitiesController do
  let(:business) { Business.new }
  let(:featured) { Business.new(:featured => true) }

  describe "GET 'show'" do
    before :each do
      businesses = mock
      community = mock_model(Community, :businesses => businesses, :users => [User.new]) 
      businesses.stub_chain('ordered.category.paginate') { [business, featured] }
      Community.stub(:where) { [:other_community] }
      Community.stub_chain('includes.find') { community }
      get :show, :id => :id
    end

    it "shows the page" do
      response.should be_success 
    end

    it "assigns @communities" do
      assigns(:communities).should == [:other_community]
    end
  end
    
end
