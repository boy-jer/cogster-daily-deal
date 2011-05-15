require 'spec_helper'

describe Admin::ProjectOptionsHelper do
  it "has a helper for interval count" do
    @project_option = mock_model(ProjectOption, :redemption_schedule => [1,2,3])
    helper.fewer_intervals.should == 2
  end
end
