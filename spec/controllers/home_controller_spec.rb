require 'spec_helper'

describe HomeController do

  describe "GET 'index'" do
    before :each do
      get 'index'
    end

    it "should be successful" do
      response.should be_success
    end

    it "sets @communities" do
      assigns(:communities).should_not be_nil
    end
  end

end
