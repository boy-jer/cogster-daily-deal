require 'spec_helper'

describe User do
  its(:address) { should_not be_nil }
  its(:role)    { should == 'cogster' }  
  
  describe "has a name" do
    subject { User.new(:first_name => "Dan", :last_name => "Bisbee") }

    its(:name) { should == "Dan Bisbee" }
    its(:abbr_name) { should == "Dan B" }
  end

  it "can be a merchant" do
    user = User.new
    user.role = "merchant"
    user.should be_merchant
  end

  it "can be an admin" do
    user = User.new
    user.role = "admin"
    user.should be_admin
  end

  it "has 10-digit cogster id" do
    user = Factory.create(:user)
    user.cogster_id.size.should == 9
    user.cogster_id.should match(/[0-9A-F]{9}/)
  end
end
