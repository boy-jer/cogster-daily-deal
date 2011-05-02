require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the BusinessOptionsHelper. For example:
#
# describe BusinessOptionsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe Admin::BusinessOptionsHelper do
  describe "#menu" do
    it "hooks the index of business options to admin menu" do
      helper.should_receive(:action_name).and_return 'index'
      helper.menu.should == helper.admin_menu_front
    end

    it "hooks other actions to breadcrumbs" do
      helper.stub(:action_name).and_return 'new'
      helper.menu.should == helper.admin_menu_back
    end
  end

  it "matches #admin_menu_back to breadcrumbs to controller index" do
    helper.should_receive(:admin_business_options_path).and_return 'route'
    helper.should_receive(:controller_title).and_return 'Business Options'
    helper.should_receive(:action_name).and_return 'new'
    crumbs = [link_to('Business Options', 'route'), 'New']
    helper.admin_menu_back.should == helper.breadcrumbs(crumbs)
  end

end
