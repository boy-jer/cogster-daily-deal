require 'spec_helper'

describe Purchase do
  before :each do
    @purchase = Purchase.new
    @purchase.security_code = "text"
  end

  it "selects coupons valid this week" do
    3.times{|n| @purchase.coupons.build }
    @purchase.coupons.each_with_index do |c,i|
      c.should_receive(:good_during_week_of?).and_return(i % 2 == 0)
    end
    @purchase.stub(:project).and_return project = mock_model(Project)
    @purchase.coupons.for_week_and_project(Date.today, project).size.should == 2
  end

  it "gets balance from current coupon" do
    @purchase.stub(:current_coupon).and_return mock_model(Coupon, :used? => false, :amount => 20)
    @purchase.current_balance.should == 20
  end

  it "detects which coupon is current" do
    expired = mock_model(Coupon, :current? => false)
    future = mock_model(Coupon, :current? => false)
    current = mock_model(Coupon, :current? => true)
    @purchase.should_receive(:coupons).and_return [expired, current, future]
    @purchase.current_coupon.should == current
  end

  describe "upon save" do
    before :each do
      @purchase.should_receive(:valid?).and_return true
      @purchase.user = Factory.build(:user)
      @purchase.amount = 100
      schedule = [{ :duration => 7, :percentage => 75 },
                  { :duration => 7, :percentage => 50 }]
      @purchase.should_receive(:redemption_schedule).and_return schedule
      @purchase.should_receive(:process_with_active_merchant).and_return true
      @purchase.should_receive(:save_paypal_response).and_return true
      @purchase.should_receive(:increment_project).and_return true
    end

    it "creates its own coupons" do
      params_1 = { :start_date => Date.today, :amount => 75.0, :expiration_date => Date.today + 6 }
      params_2 = { :start_date => Date.today + 7, :amount => 50.0, :expiration_date => Date.today + 13 }
      @purchase.coupons.should_receive(:create).with(params_1)
      @purchase.coupons.should_receive(:create).with(params_2) 
      @purchase.should_receive(:send_email).and_return true
      @purchase.save
    end

    it "sends an email" do
      reset_mailer
      @purchase.stub(:current_coupon).and_return mock_model(Coupon, :business => Business.new(:name => 'test'), :expiration_date => Date.today)
      @purchase.save
      unread_emails_for(@purchase.user.email).should have(1).message
    end

    it "saves address for user" do
      @purchase.stub(:send_email) { true }
      @user = @purchase.user
      @user.save
      @purchase.user.address = Address.new(:line_1 => "Main St", :city => "Selingsgrove", :state => "PA", :zip => "17870", :country => "United States")
      @purchase.save
      @user.address.should be_persisted
      Address.find_by_addressable_id(@user).line_1.should == "Main St"
    end

  end

end
