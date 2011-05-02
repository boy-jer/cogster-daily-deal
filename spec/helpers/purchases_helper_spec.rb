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
  
  it "provides options for purchase" do
    helper.should_receive(:current_user).and_return user = mock_model(User)
    project = mock_model(Project)
    project.should_receive(:steps_for).with(user).and_return [10, 20]
    helper.purchase_options(project).should == [["$10.00", 10], ["$20.00", 20]]
  end

  describe "#purchase_selection" do
    before :each do
      @project = mock_model(Project, :min_amount => 10)
    end
    it "uses previously selected amount if there is one" do
      assign(:purchase, mock_model(Purchase, :amount => 20))
      helper.purchase_selection(@project).should == 20
    end

    it "falls back on project min amount if purchase has no amt" do
      assign(:purchase, mock_model(Purchase, :amount => nil))
      helper.purchase_selection(@project).should == 10
    end
  end

  it "formats redemption amount" do
    project = mock_model(Project)
    project.should_receive(:min_redemption_amount).with(1).and_return 500
    helper.redemption_amount(project, 1).should == "$5.00"
  end
end
