require 'spec_helper'

describe Community do
  it "uses given handle" do
    community = Community.new(:handle => 'the-grove')
    community.handle.should == 'the-grove'
  end

  it "changes name into handle if no handle present" do
    community = Community.new(:name => "The Grove")
    community.handle.should == 'the-grove'
  end

  it "incorporates state into handle if state is given but handle is not" do
    community = Community.new(:name => "The Grove", :state => "PA")
    community.handle.should == 'the-grove-pa'
  end

  it "collects purchases from businesses" do
    community = Community.new
    biz_1 = mock_model(Business, :purchases => [:purchase_1])
    biz_2 = mock_model(Business, :purchases => [:purchase_2, :purchase_3])
    community.stub(:businesses).and_return [biz_1, biz_2]
    community.purchases.should == [:purchase_1, :purchase_2, :purchase_3]
  end

  it "calculates swag counter based on all purchases" do
    community = Community.new
    purchase_1 = mock_model(Purchase, :amount => 20)
    purchase_2 = mock_model(Purchase, :amount => 10)
    community.stub(:purchases).and_return [ purchase_1, purchase_2 ]
    community.swag_counter.should == 508500
  end

  it "calculates swag rank for a user" do
    community = Community.new
    high_user = mock_model(User, :earnings => 100)
    mid_user = mock_model(User, :earnings => 50)
    low_user = mock_model(User, :earnings => 0)
    community.stub(:users).and_return [mid_user, high_user, low_user]
    community.users.map(&:earnings).should == [50,100,0]
    [50,100,0].uniq.sort.should == [0,50,100]
    community.users.map(&:earnings).uniq.sort.should == [0,50,100]
    community.users.map(&:earnings).uniq.sort.should == community.earnings_levels
    community.earnings_levels.should == [0,50,100]
    community.swag_rank(high_user).should == 0.0
    community.swag_rank(low_user).should be_within(0.1).of(66.7)
  end

  it "destroys community request after it is used" do
    community = Factory.build(:community)
    community.community_request_id = 1
    community.request_message = "thanks"
    request = mock_model(CommunityRequest)
    request.should_receive(:destroy_with_positive_feedback).with("thanks")
    CommunityRequest.should_receive(:find).with(1).and_return request
    community.save
    community.id.should_not be_nil
  end
end
