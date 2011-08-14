require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the PurchasesHelper. For example:
#
# describe PurchasesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe PurchasesHelper do
  
  it "formats redemption amount" do
    project = mock_model(Project)
    project.should_receive(:min_redemption_amount).with(1).and_return 500
    helper.redemption_amount(project, 1).should == "$5.00"
  end
end
