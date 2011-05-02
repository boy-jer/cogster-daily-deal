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
    @purchase.should_receive(:current_coupon).and_return mock_model(Coupon, :remainder => 20)
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
    end

    it "creates its own coupons" do
      params_1 = { :start_date => Date.today, :initial_amount => 75.0, :expiration_date => Date.today + 6 }
      params_2 = { :start_date => Date.today + 7, :initial_amount => 50.0, :expiration_date => Date.today + 13 }
      @purchase.coupons.should_receive(:create).with(params_1)
      @purchase.coupons.should_receive(:create).with(params_2) 
      @purchase.should_receive(:send_email).and_return true
      @purchase.save
    end

    it "sends an email" do
      reset_mailer
      @purchase.save
      unread_emails_for(@purchase.user.email).should have(1).message
    end
  end

end
