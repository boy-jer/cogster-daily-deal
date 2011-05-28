require 'spec_helper'

describe PurchasesController do
  let(:community) { mock_model(Community) }
  let(:project)   { mock_model(Project, :accepting_purchases? => true, :max_amount => 10)}
  before :each do
    Business.should_receive(:find).with(:business_id) { mock_model(Business, :community => community, :current_project => project, :name => 'Biz')}
    log_in
  end

  describe "POST create" do
    before :each do
      @purchase = Purchase.new
      @user.purchases.should_receive(:build).with({ 'some' => :params}) { @purchase }
      
    end

    describe "on save" do
      before :each do
        @purchase.should_receive(:save).and_return true
        @purchase.should_receive(:current_balance).and_return 5.0
        post :create, :business_id => :business_id, :purchase => { 'some' => :params }
      end
      it "redirects" do
        response.should be_redirect
      end

      it "displays the purchase balance in the flash" do
        flash[:notice].should =~ /\$5\.00/
      end
    end
      
  end
end
