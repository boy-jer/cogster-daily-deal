require 'spec_helper'

describe ApplicationHelper do

  it "should link to current community if available" do
    community = mock_model(Community, :name => "The Grove", :to_param => 'id')
    current_community_link(community).should == link_to("The Grove", community_path(community))
  end

  it "should provide text if no current community" do
    current_community_link(nil).should == "Choose a community"
  end
end
