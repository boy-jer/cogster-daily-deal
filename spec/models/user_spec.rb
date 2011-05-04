require 'spec_helper'

describe User do
  let(:user) { User.new }
  let(:completed_project) { mock_model(Project, :accepting_purchases? => false)}
  let(:open_project) { mock_model(Project, :max_amount => 50, :accepting_purchases? => true)}
  its(:address) { should_not be_nil }
  its(:role)    { should == 'cogster' }  
  
  describe "has a name" do
    subject { User.new(:first_name => "Dan", :last_name => "Bisbee") }

    its(:name) { should == "Dan Bisbee" }
    its(:abbr_name) { should == "Dan B" }
  end

  it "can be a merchant" do
    user.role = "merchant"
    user.should be_merchant
  end

  it "can be an admin" do
    user.role = "admin"
    user.should be_admin
  end

  it "has 10-digit cogster id" do
    user = Factory.create(:user)
    user.cogster_id.size.should == 9
    user.cogster_id.should match(/[0-9A-F]{9}/)
  end

  describe "#may_make_purchase_for?" do
    
    it "may not if project is complete" do
      user.may_make_purchase_for?(completed_project).should be_false  
    end

    it "may not if user has maxed out on project" do
      user.stub(:purchases_of).with(open_project).and_return(50)
      user.may_make_purchase_for?(open_project).should be_false  
    end

    it "may if user has not maxed out and project is incomplete" do
      user.stub(:purchases_of).with(open_project).and_return 0
      user.may_make_purchase_for?(open_project).should be_true
    end
  end
end
