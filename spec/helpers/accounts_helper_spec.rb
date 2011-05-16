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

    it "shows text if coupon current but worthless" do
      coupon = mock_model(Coupon, :expired? => false, :future? => false, :used? => true)
      helper.cash_link(coupon).should == 'Spent'
    end

    it "shows link to cash page if coupon for present and has value" do
      purchase = mock_model(Purchase, :to_param => '1')
      coupon = mock_model(Coupon, :expired? => false, :future? => false, :purchase => purchase, :used? => false) 
      helper.cash_link(coupon).should match(/Print Cash/)
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

end
