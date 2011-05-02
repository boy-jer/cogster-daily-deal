require 'spec_helper'

describe RedemptionsController do
  before :each do
    sign_in_as_admin
  end

  describe "POST 'create'" do
    
    before :each do
      @coupon = Coupon.new
      Coupon.stub(:find) { @coupon }
      @redemption = mock_model(Redemption)
      @coupon.redemptions.stub(:new) { @redemption }
    end

    it "redirects on success" do
      @redemption.stub(:save).and_return true
      post :create, :id => :id, :business_id => :business_id, :redemption => { :valid => :params }
      response.should be_redirect
    end

  end

end
