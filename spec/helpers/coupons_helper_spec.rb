require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the CouponsHelper. For example:
#
# describe CouponsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe CouponsHelper do

  describe "#redemption_date_range" do
    it "goes from coupon start date to today if expiration is in future" do
      assign(:coupon, mock_model(Coupon, :start_date => Date.today - 1, :expiration_date => Date.today + 1))
      helper.redemption_date_range.should == (Date.today - 1..Date.today)
    end

    it "goes from start date to expiration date if expiration has passed" do
      assign(:coupon, mock_model(Coupon, :start_date => Date.today - 2, :expiration_date => Date.today - 1))
      helper.redemption_date_range.should == (Date.today - 2..Date.today - 1)
    end
  end
end
