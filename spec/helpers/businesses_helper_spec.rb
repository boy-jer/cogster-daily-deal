require 'spec_helper'

describe BusinessesHelper do
  let(:user){ mock_model(User) }

  describe "#conditional_purchase_link" do
    before :each do
      @business = mock_model(Business, :to_param => '1-biz')
    end

    it "renders link to purchase if user may make purchase" do
      helper.stub(:purchase_possible?).and_return true
      helper.conditional_purchase_link('text', {}).should ==
        link_to('text', new_business_purchase_url(@business, :protocol => 'https'), {})
    end

    describe "if user may not purchase" do
      before :each do
        helper.stub(:purchase_possible?).and_return false
      end
      it "renders span if text given" do
        helper.stub(:current_user_involved?).and_return 'supported'
        helper.conditional_purchase_link('text', {}, 'alt text').should == 
          content_tag(:span, 'alt text', :class => 'supported')
      end

      it "renders nothing if no text given" do
        helper.conditional_purchase_link('text', {}).should be_nil
      end
    end
  end

  describe "#current_user_involved?" do

    it "returns nil if no current user" do
      helper.stub(:current_user).and_return nil
      helper.current_user_involved?.should be_nil
    end

    describe "if current user" do
      before :each do
        @business = mock_model(Business, :current_project => :project)
        helper.stub(:current_user).and_return user
      end

      it "returns 'supported' if user made purchase" do
        user.should_receive(:made_purchase_for?).with(:project).and_return true 
        helper.current_user_involved?.should == 'supported'
      end
      it "returns nil if user made no purchase" do
        user.should_receive(:made_purchase_for?).with(:project).and_return false
        helper.current_user_involved?.should be_nil
      end
    end
  end

  describe "#dt_dd" do
    it "returns nil if the given attribute for the given obj is blank" do
      business = mock_model(Business, :attribute => nil)
      helper.dt_dd(business, 'attribute').should be_nil
    end

    it "returns a defn list if the given attribute is not blank" do
      business = mock_model(Business, :attribute => 'value')
      helper.dt_dd(business, 'attribute').should == 
        content_tag(:dt, 'Attribute') + content_tag(:dd, 'value')
    end
  end

  describe "#dt_dds" do
    it "returns nil if the given collection for the given obj is empty" do
      business = mock_model(Business, :collection => [])
      helper.dt_dds(business, 'collection', :attribute).should be_nil
    end
      
    it "returns nil if given collection are all new objects" do
      business = mock_model(Business, :collection => [mock_model(Website, :persisted? => false)])
      helper.dt_dds(business, 'collection', :attribute).should be_nil
    end
      
    it "returns defn list w links to each saved member of collection if any" do
      website = mock_model(Website, :persisted? => true, :url => 'www.site.com')
      facebook = mock_model(Website, :persisted? => true, :url => 'www.facebook.com')
      new_twitter = mock_model(Website, :persisted? => false)
      business = mock_model(Business, :collection => [website, facebook, new_twitter])
      helper.dt_dds(business, 'collection', :url).should == 
        content_tag(:dt, 'Collection') + 
        [content_tag(:dd, link_to('www.site.com', 'www.site.com', :target => '_blank')),
         content_tag(:dd, link_to('www.facebook.com', 'www.facebook.com', :target => '_blank'))].join.html_safe
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
        helper.purchase_possible?.should be_true
      end
        
      it "returns false if user may not" do
        user.should_receive(:may_make_purchase_for?).with(:project) { false}
        helper.purchase_possible?.should be_false
      end
    end

    describe "no current user" do
      before :each do
        helper.stub(:current_user).and_return nil
        @business = mock_model(Business)
      end
      it "returns true if business is accepting purchases" do
        @business.should_receive(:accepting_purchases?).and_return true
        helper.purchase_possible?.should be_true 
      end

      it "returns false otherwise" do
        @business.should_receive(:accepting_purchases?).and_return false
        helper.purchase_possible?.should be_false
      end
    end
  end
end
