require 'spec_helper'

describe Community do
  it "uses given handle" do
    community = Community.new(:handle => 'the-grove')
    community.handle.should == 'the-grove'
  end

  it "changes name into handle if no handle present" do
    community = Community.new(:name => "The Grove")
    community.handle.should == 'the-grove'
  end

  it "incorporates state into handle if state is given but handle is not" do
    community = Community.new(:name => "The Grove", :state => "PA")
    community.handle.should == 'the-grove-pa'
  end
end
