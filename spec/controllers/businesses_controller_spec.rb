require 'spec_helper'

describe BusinessesController do

  describe "GET 'index'" do
    it "works" do
      get :index
      response.should be_success 
    end
  end

  describe "GET 'show'" do
    it "works" do
      Business.stub_chain('includes.find') { mock_model(Business, :active => true, :community => Community.new) }
      get :show, :id => :id
      response.should be_success 
    end
  end
end
