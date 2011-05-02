require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the AccountHelper. For example:
#
# describe AccountHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe AccountsHelper do
  describe "#admin_or_merchant_view_button" do
    it "shows nothing if current_user is cogster" do
      helper.should_receive(:current_user).and_return mock_model(User, :role => 'cogster')
      helper.admin_or_merchant_view_button.should be_nil
    end

    describe "for admin" do
      before :each do
        helper.stub(:current_user).and_return mock_model(User, :role => 'admin')
      end

      it "shows nothing if session is not set" do
        helper.admin_or_merchant_view_button.should be_nil
      end

      describe "when session[:cogster] is set" do
        before :each do
          session[:cogster] = true
        end
        it "shows title" do
          helper.admin_or_merchant_view_button.should match(/<h2/)
        end

        it "shows button" do
          helper.admin_or_merchant_view_button.should match(/Admin View/)
        end
      end
    end
  end

  describe "#cash_link" do
    it "shows text if coupon expired" do
      coupon = mock_model(Coupon, :expired? => true)
      helper.cash_link(coupon).should == 'Expired'
    end

    it "shows text if coupon for future" do
      coupon = mock_model(Coupon, :expired? => false, :future? => true)
      helper.cash_link(coupon).should == 'Future'
    end

    it "shows link to cash page if coupon for present" do
      purchase = mock_model(Purchase, :to_param => '1')
      coupon = mock_model(Coupon, :expired? => false, :future? => false, :purchase => purchase)
      helper.cash_link(coupon).should match(/Print Cash/)
    end
  end

  describe "#coupon_rows" do
    before :each do
      @user = mock_model(User, :abbr_name => 'Dan B', :cogster_id => '123456789')
      @coupons = [mock_model(Coupon), mock_model(Coupon)]
      helper.stub(:valid_days_for).and_return helper.content_tag(:td, 'valid')
    end

    it "has one element per coupon" do
      helper.coupon_rows(@coupons, @user).size.should == 2
    end

    it "has user name in each element" do
      helper.coupon_rows(@coupons, @user)[0].should match(/Dan B/)
    end

    it "has tds in each element" do
      helper.coupon_rows(@coupons, @user)[0].scan(/<td/).size.should == 3
    end
  end

  describe "#expiration_status" do
    it "notes expired" do
      coupon = mock_model(Coupon, :expired? => true)
      helper.expiration_status(coupon).should == 'odd expired'
    end

    it "notes active" do
      coupon = mock_model(Coupon, :expired? => false, :future? => false)
      helper.expiration_status(coupon).should == 'odd active'
    end

    it "just cycles for future" do
      coupon = mock_model(Coupon, :expired? => false, :future? => true)
      helper.expiration_status(coupon).should == 'odd '
    end
  end

  describe "#redeemable_coupons_for" do
    before :each do
      assign(:monday, Date.today - 2)
      assign(:current_project, @project = mock_model(Project))
      @user = mock_model(User)
      @purchase = Purchase.new 
    end

    it "returns '' if there are no coupons" do
      helper.redeemable_coupons_for(@user, @purchase).should == ''
    end

    it "returns set of tr elements" do
      @purchase.coupons.should_receive(:for_week_and_project).and_return :coupons
      helper.should_receive(:coupon_rows).with(:coupons, @user).and_return %w(one two three)
      helper.redeemable_coupons_for(@user, @purchase).scan(/<tr/).size.should == 3
    end
  end

   describe "#valid_days_for" do
     before :each do
       assign(:monday, Date.today)
       @coupon = mock_model(Coupon, :start_date => Date.today, :expiration_date => Date.today + 7, :remainder => 10)
       business = mock_model(Business, :to_param => '1-business')
       assign(:current_project, mock_model(Project, :business => business))
     end

     it "shows one td if coupon is valid all week" do
       helper.valid_days_for(@coupon).scan(/<td/).size.should == 1
     end

     it "shows 2 tds if coupon becomes valid during week" do
       @coupon.stub(:start_date).and_return Date.today + 1
       helper.valid_days_for(@coupon).scan(/<td/).size.should == 2
     end

     it "shows 2 tds if coupon becomes invalid during week" do
       @coupon.stub(:expiration_date).and_return Date.today + 5
       helper.valid_days_for(@coupon).scan(/<td/).size.should == 2
     end

     it "shows 3 tds if coupon is invalid at start and end of week" do
       @coupon.stub(:start_date).and_return Date.today + 1
       @coupon.stub(:expiration_date).and_return Date.today + 5
       helper.valid_days_for(@coupon).scan(/<td/).size.should == 3
     end
   end
end
