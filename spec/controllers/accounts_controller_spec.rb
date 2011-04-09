require 'spec_helper'

describe AccountsController do
  include Devise::TestHelpers

  describe "GET 'edit'" do
    context "merchant user" do
    
      before :each do
        user = Factory.create(:merchant)
        user.confirm!
        user.stub(:business) { mock_model(Business) }
        sign_in :user, user
        get :edit
      end

      it "uses the merchant template" do
        response.should render_template('edit_merchant')
      end
    
      it "assigns @business" do
        assigns(:business).should_not be_nil
      end
    end
  end

  describe "GET 'show'" do
    %w(user admin merchant).each do |role|
      it "renders #{role} template for #{role}" do
        user = Factory.create(role.to_sym)
        user.confirm!
        sign_in :user, user
        get :show
        response.should render_template(role.to_sym)
      end
    end
  end

end
