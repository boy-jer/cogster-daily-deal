require 'spec_helper'

describe ApplicationHelper do

  describe "#admin_menu" do
    it "hooks index to admin menu" do
      helper.should_receive(:action_name).and_return 'index'
      helper.should_receive(:admin_menu_front).and_return :menu
      helper.admin_menu.should == :menu
    end

    it "hooks other action to back end" do
      helper.should_receive(:action_name).and_return 'new'
      helper.should_receive(:admin_menu_back).and_return :breadcrumbs
      helper.admin_menu.should == :breadcrumbs
    end
  end

  describe "#admin_menu_back" do
    it "returns breadcrumb path to controller index" do
      helper.should_receive(:controller_index_link).and_return :link
      helper.should_receive(:action_name).and_return 'new'
      helper.should_receive(:breadcrumbs).with([:link, 'New']).and_return :result
      helper.admin_menu_back.should == :result
    end
  end

  describe "#breadcrumbs" do
    it "joins array elements" do
      helper.breadcrumbs(%w(one two three)).should == content_tag(:div, "one&rarr;two&rarr;three".html_safe, :id => "breadcrumbs")
    end

    it "flattens and joins array elements" do
      helper.breadcrumbs([%w(one two), 'three']).should == content_tag(:div, "one&rarr;two&rarr;three".html_safe, :id => "breadcrumbs")
    end
  end

  describe "#business_image" do
    it "has one image tag if business is not featured" do
      business = stub_model(Business)
      helper.business_image(business).scan(/img /).size.should == 1
    end

    it "has two image tags if business is featured" do
      business = stub_model(Business, :featured? => true)
      helper.business_image(business).scan(/img /).size.should == 2
    end
  end

  describe "#community_name" do
    it "returns 'Other' if there is no community_id or signed in user" do
      helper.stub(:user_signed_in?){ nil }
      helper.community_name.should == 'Other'
    end

    it "returns 'Other' if the first business is not from the community" do
      helper.stub(:params).and_return({ :community_id => 1}) 
      assign(:community, mock_model(Community, :id => 1))
      assign(:businesses, [mock_model(Business, :community_id => 2)])
      helper.community_name.should == 'Other'
    end

    it "returns the name of the 1st business community if it matches user" do
      assign(:community, mock_model(Community, :id => 1, :name => 'The Grove'))
      assign(:businesses, [mock_model(Business, :community_id => 1)])
      helper.should_receive(:user_signed_in?){ true }
      helper.community_name.should == 'The Grove'
    end
  end

  describe "#controller_index_link" do
    it "does what it says" do
      helper.should_receive(:controller_title).and_return :title
      helper.should_receive(:controller_index_path).and_return '/path'
      helper.controller_index_link.should == helper.link_to(:title, '/path')
    end
  end

  describe "#controller_index_path" do
    it "gets path to controller index" do
      helper.should_receive(:controller_path).and_return 'admin/business_options'
      helper.controller_index_path.should == '/admin/business_options'
    end
  end

  it "formats the #controller_title" do
    helper.should_receive(:controller_name).and_return 'business_options'
    helper.controller_title.should == 'Business Options'
  end
    
  describe "#current_community" do
    it "should link to current community if available" do
      community = mock_model(Community, :name => "The Grove", :to_param => 'id')
      current_community_link(community).should == link_to("The Grove", community_path(community))
    end

    it "should provide text if no current community" do
      current_community_link(nil).should == "Choose a community"
    end
  end

  describe "#featured_tag" do
    it "returns nil if business is not featured" do
      business = mock_model(Business, :featured? => false)
      helper.featured_tag(business).should be_nil
    end

    it "returns image tag otherwise" do
      business = mock_model(Business, :featured? => true)
      helper.featured_tag(business).should match(/featured_overlay.png/)
    end
  end

  describe "#login_link" do
    it "returns nil if user is logged in" do
      helper.should_receive(:user_signed_in?).and_return true
      helper.login_link.should be_nil
    end

    it "shows login link if user has not logged in" do
      helper.should_receive(:user_signed_in?).and_return false
      helper.login_link.should match(/Log In/)
    end
  end

  describe "#menu" do
    it "hooks the index of business options to admin menu" do
      helper.stub(:controller_path).and_return 'admin/business_options'
      helper.should_receive(:action_name).and_return 'index'
      helper.menu.should == helper.admin_menu_front
    end

    it "hooks controllers outside of admin namespace to generic menu" do
      helper.stub(:controller_path).and_return 'communities'
      helper.should_receive(:menu_without_business_filters).and_return 'txt'
      helper.should_receive(:render).and_return '_partial'
      helper.menu.should == 'txt_partial'
    end
  end

  describe "#none_like" do
    it "mentions the search term if there was one" do
      helper.stub(:params).and_return({ :search => 'Meaning' }) 
      helper.none_like.should match(/Meaning/)
    end

    it "has generic text if there was a filter" do
      helper.stub(:params).and_return({ :filter => 'Restaurants' }) 
      helper.none_like.should_not be_empty
    end

    it "is blank if neither of those params are present" do
      helper.stub(:params).and_return({}) 
      helper.none_like.should be_nil
    end
  end

end
