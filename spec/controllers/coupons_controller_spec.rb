require 'spec_helper'

describe CouponsController do
  before :each do
    Business.should_receive(:find).with(:business_id) { mock_model(Business)}
    sign_in_as_admin
  end

  describe "GET 'edit'" do
    it "works" do
      Coupon.stub_chain('includes.find') { mock_model(Coupon, :user => User.new) }
      get :edit, :id => :id, :business_id => :business_id
      response.should be_success 
    end
  end

  describe "PUT 'update'" do
    context "on success" do
      it "works" do
        Coupon.should_receive(:find).with(:id) { mock_model(Coupon, :update_attributes => true) }
        put :update, :id => :id, :business_id => :business_id
        response.should be_redirect
      end
    end

    context "on failure" do
      it "renders edit form" do
        Coupon.should_receive(:find).with(:id) { mock_model(Coupon, :update_attributes => false) }
        put :update, :id => :id, :business_id => :business_id
        response.should render_template('edit')
      end
    end
  end
end
