require 'spec_helper'

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

  describe "#role_options" do
    it "provides merchant as a choice if user has a business" do
      user = mock_model(User, :business => true)
      helper.role_options(user).should include('merchant')
    end

    it "skips choice of merchant if user has no business" do
      user = mock_model(User, :business => nil)
      helper.role_options(user).should_not include('merchant')
    end
  end

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
    helper.should_receive(:admin_users_path).and_return 'route'
    helper.should_receive(:controller_title).and_return 'Users'
    helper.should_receive(:action_name).and_return 'new'
    crumbs = [link_to('Users', 'route'), 'New']
    helper.admin_menu_back.should == helper.breadcrumbs(crumbs)
  end

end
