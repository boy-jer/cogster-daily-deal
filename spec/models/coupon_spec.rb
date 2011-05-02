require 'spec_helper'

describe Coupon do
  before :each do
    @coupon = Factory.build(:coupon)
  end

  it "detects current" do
    @coupon.should be_current
  end

  it "tracks expiration" do
    @coupon.expiration_date = Date.today - 1
    @coupon.should be_expired
  end

  it "tracks future" do
    @coupon.start_date = Date.today + 1
    @coupon.should be_future
  end

  it "is good between start and expiration" do
    @coupon.should_not be_future
    @coupon.should_not be_expired
    @coupon.good_during_week_of?(Date.today).should be_true
  end

  it "creates a record of a redemption when it is updated" do
    @coupon.save
    sale_date = Date.today - 1
    @coupon.remainder = 20
    amount = BigDecimal.new('15', 9)
    @coupon.redemption_amount = amount
    @coupon.redemption_date = sale_date
    redemption_params = { :date => sale_date, :amount => amount } 
    @coupon.redemptions.should_receive(:create).with redemption_params
    @coupon.save
    @coupon.remainder.should be_within(0.1).of(5)
  end

  it "sets remainder upon creation" do
    @coupon.remainder = nil
    @coupon.save
    @coupon.remainder.should == @coupon.initial_amount
  end

  describe "#check_for_status_change" do

    before :each do
      reset_mailer
      @user = Factory.build(:user)
    end
    it "does nothing if coupon is not yet valid" do
      @coupon.expiration_date = Date.today + 20
      @coupon.start_date = Date.today + 10
      @coupon.check_for_status_change(:user).should be_false
      unread_emails_for(@user.email).should have(0).messages
    end

    it "does nothing if coupon expired" do
      @coupon.expiration_date = Date.today - 10
      @coupon.start_date = Date.today - 20
      @coupon.check_for_status_change(@user).should be_false
      unread_emails_for(@user.email).should have(0).messages
    end

    describe "acts here" do
      before :each do
        biz = mock_model(Business, :name => 'BJ')
        @coupon.purchase = mock_model(Purchase, :business => biz)
      end

      it "sends warning if coupon about to expire" do
        @coupon.expiration_date = Date.today + 2
        @coupon.check_for_status_change(@user)
        unread_emails_for(@user.email).should have(1).message
      end
      
      it "sends notice for new coupon" do
        @coupon.start_date = Date.today
        @coupon.check_for_status_change(@user)
        unread_emails_for(@user.email).should have(1).message
      end
    end

    it "does nothing for current coupon with no value" do
      @coupon.expiration_date = Date.today + 2
      @coupon.remainder = 0
      @coupon.check_for_status_change(@user)
      unread_emails_for(@user.email).should have(0).messages
    end

  end
end
