require 'spec_helper'

describe AccountsController do

  describe "GET 'cash'" do
    before :each do
      log_in
      @user.purchases.stub(:find).with(1, :include => :coupons) { mock_model(Purchase, :current_coupon => Coupon.new) }
      get :cash, :id => 1
    end

    it "renders cash template" do
      response.should render_template('cash')
    end

    it "assigns @purchase" do
      assigns(:purchase).should_not be_nil
    end

  end

  describe "GET 'edit'" do

    context "admin user" do

      it "uses the default template" do
        sign_in Factory.create(:admin)
        get :edit
        response.should render_template('edit')
      end
    end
  end

  describe "GET 'show'" do
    %w(user admin merchant).each do |role|
      it "renders #{role} template for #{role}" do
        sign_in Factory.create(role.to_sym)
        get :show
        role = 'cogster' if role == 'user'
        response.should render_template(role.to_sym)
      end
    end

    context "when session[:cogster] is set" do
      before :each do
        session[:cogster] = true
      end

      context "an admin user" do
        before :each do
          sign_in Factory.create(:admin)
          get :show
        end

        it "sees cogster template" do
          response.should render_template('cogster')
        end

        it "assigns @purchases" do
          assigns(:purchases).should_not be_nil
        end
      end

      context "a merchant" do
        before :each do
          sign_in Factory.create(:merchant)
          get :show
        end

        it "sees cogster template" do
          response.should render_template('cogster')
        end

        it "assigns @purchases" do
          assigns(:purchases).should_not be_nil
        end
      end
    end
  end

  describe "PUT 'update'" do
    before :each do
      @user = Factory.create(:user)
      sign_in @user
    end

    context "toggling status" do
      it "succeeds in turning on" do
        put :update, :id => @user.id, :toggle => true
        session[:cogster].should be_true
      end

      it "succeeds in turning off" do
        session[:cogster] = true
        put :update, :id => @user.id, :toggle => true
        session[:cogster].should be_nil
      end

      it "redirects to account" do
        put :update, :id => @user.id, :toggle => true
        response.should redirect_to(account_path)
      end
    end

    context "updating attributes" do
      before :each do
        controller.stub(:current_user) { @user }
      end

      it "redirects for success" do
        @user.should_receive(:update_attributes).with({ 'valid' => :params }).and_return true
        put :update, :id => @user.id, :user => { :valid => :params }
        response.should redirect_to(account_path)
      end

      context "on failure" do
        it "renders edit template for user" do
          @user.should_receive(:update_attributes).with({ 'invalid' => :params}).and_return false
          put :update, :id => @user.id, :user => { :invalid => :params }
          response.should render_template('edit')
        end

        it "renders edit merchant template for merchant" do
          @user.stub(:merchant?).and_return true
          @user.should_receive(:update_attributes).with({ 'invalid' => :params}).and_return false
          put :update, :id => @user.id, :user => { :invalid => :params }

        end
      end
    end
  end
end
