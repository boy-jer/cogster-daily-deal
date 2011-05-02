require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the UsersHelper. For example:
#
# describe UsersHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe Admin::UsersHelper do
  describe "#last_sign_in_for" do
    it "returns string if no last_sign_in" do
      user =  mock_model(User, :last_sign_in_at => nil)
      helper.last_sign_in_for(user).should == 'N/A'
    end

    it "returns sign in time if it exists" do
      time = Time.now
      user = mock_model(User, :last_sign_in_at => time)
      helper.last_sign_in_for(user).should == time.strftime("%r %b %d")
    end
  end
end
