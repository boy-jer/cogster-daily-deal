require 'spec_helper'

describe BusinessesHelper do
  let(:user){ mock_model(User) }

  describe "#conditional_purchase_link" do
    before :each do
      @business = mock_model(Business, :to_param => '1-biz')
    end

    it "renders link to purchase if user may make purchase" do
      helper.stub(:purchase_possible?).and_return true
      helper.conditional_purchase_link('text', @business, {}).should ==
        link_to('text', new_business_purchase_url(@business, :protocol => 'https'), {})
    end

    describe "if user may not purchase" do
      before :each do
        helper.stub(:purchase_possible?).and_return false
      end
      it "renders span if text given" do
        helper.stub(:current_user_involved?).and_return 'supported'
        helper.conditional_purchase_link('text', @business, {}, 'alt text').should == 
          content_tag(:span, 'alt text', :class => 'supported')
      end

      it "renders nothing if no text given" do
        helper.conditional_purchase_link('text', @business, {}).should be_nil
      end
    end
  end

  describe "#current_user_involved?" do

    it "returns nil if no current user" do
      helper.stub(:current_user).and_return nil
      helper.current_user_involved?(Business.new).should be_nil
    end

    describe "if current user" do
      before :each do
        @business = mock_model(Business, :current_project => :project)
        helper.stub(:current_user).and_return user
      end

      it "returns 'supported' if user made purchase" do
        user.should_receive(:made_purchase_for?).with(:project).and_return true 
        helper.current_user_involved?(@business).should == 'supported'
      end
      it "returns nil if user made no purchase" do
        user.should_receive(:made_purchase_for?).with(:project).and_return false
        helper.current_user_involved?(@business).should be_nil
      end
    end
  end

  describe "#dt_dd_phone" do
    it "returns nil if the phone is blank" do
      business = mock_model(Business, :address => true, :phone => nil)
      helper.dt_dd_phone(business).should be_nil
    end

    it "returns a defn list if the phone is not blank" do
      business = mock_model(Business, :address => true, :phone => 'number')
      helper.dt_dd_phone(business).should == 
        content_tag(:dt, 'Phone') + content_tag(:dd, 'number')
    end
  end

  describe "#purchase_possible?" do
    describe "if current user present" do
      before :each do
        helper.stub(:current_user).and_return user
        @business = mock_model(Business, :current_project => :project)
      end
      it "returns true if user may make purchase" do
        user.should_receive(:may_make_purchase_for?).with(:project) { true }
        helper.purchase_possible?(@business).should be_true
      end
        
      it "returns false if user may not" do
        user.should_receive(:may_make_purchase_for?).with(:project) { false}
        helper.purchase_possible?(@business).should be_false
      end
    end

    describe "no current user" do
      before :each do
        helper.stub(:current_user).and_return nil
        @business = mock_model(Business)
      end
      it "returns true if business is accepting purchases" do
        @business.should_receive(:accepting_purchases?).and_return true
        helper.purchase_possible?(@business).should be_true 
      end

      it "returns false otherwise" do
        @business.should_receive(:accepting_purchases?).and_return false
        helper.purchase_possible?(@business).should be_false
      end
    end
  end
end
