require 'spec_helper'

describe InformationController do

  describe "GET 'terms'" do
    it "should be successful" do
      get 'terms'
      response.should be_success
    end
  end

  describe "GET 'faq'" do
    it "should be successful" do
      get 'faq'
      response.should be_success
    end
  end

  describe "GET 'privacy'" do
    it "should be successful" do
      get 'privacy'
      response.should be_success
    end
  end

  describe "GET 'swag'" do
    it "should be successful" do
      get 'swag'
      response.should be_success
    end
  end

end
