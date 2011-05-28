require 'spec_helper'

describe Business do

  it { should have_errors_on(:name) }
  #it { should have_errors_on(:community_id) }

  before :each do
    @business = Factory.build(:business)
    @business.merchant = Factory(:merchant, :business => nil)
  end

  it "validates uniqueness of name" do
    @business.save
    Business.new(@business.attributes).should validate_uniqueness_of(:name).scoped_to(:community_id)
  end

  it "always has current project" do
    @business.current_project.should_not be_nil
  end

  it "ignores incomplete address" do
    @business.address_attributes = {'country' => 'United States', 'city' => ''}
    @business.save.should be_true
  end
   
  it "substitutes numerical id for use in url" do
    @business.stub(:id).and_return 1
    @business.name = "Mr Thrifty's $5 Emporium"
    @business.to_param.should == "1-mr-thriftys-5-emporium"
  end

  it "collects purchases from its projects" do
    project = mock_model(Project, :purchases => [:purchase_1, :purchase_2]) 
    project_2 = mock_model(Project, :purchases => [:purchase_3])
    @business.stub(:projects).and_return [ project, project_2]
    @business.purchases.should == [:purchase_1, :purchase_2, :purchase_3]
  end

  describe "activation" do
    before :each do
      @merchant = Factory(:user)
      @business.merchant = @merchant
      @merchant.save
      reset_mailer
    end

    it "sets owner role to merchant" do
      @business.update_attribute(:active, true)
      @merchant.reload.role.should == 'merchant'
    end

    it "sends message to owner" do
      @business.update_attribute(:active, true)
      unread_emails_for(@business.merchant.email).should have(1).messages
    end

    it "skips message if owner previously set to merchant" do
      @merchant.update_attribute(:role, 'merchant')
      @business.update_attribute(:active, true)
      unread_emails_for(@business.merchant.email).should have(0).messages
    end
  end

  describe "#destroy" do
    before :each do
      @business.save
    end

    it "goes quietly if no reason is given" do
      @business.destroy
      unread_emails_for(@business.merchant.email).should have(0).messages
    end

    it "sends message to wannabe merchant if Cogster rejects" do
      @business.deletion_explanation = "text"
      @business.destroy
      unread_emails_for(@business.merchant.email).should have(1).message
    end

    it "changes merchant to normal cogster" do
      @business.destroy
      @business.merchant.role.should == 'cogster'
    end
  end

  describe "#closed_on?" do
    before :each do
      @business.save
    end

    it "does not register a day as closed before any hours are set" do
      0.upto(6){|n| @business.closed_on?(n).should be_false }
    end

    it "should not register a day as closed if day has hours set" do
      @business.hours[0].open_hour = 9
      @business.closed_on?(0).should be_false
    end

    it "should register a day as closed if closed flag set for one day" do
      @business.hours[0].closed = true
      @business.closed_on?(0).should be_true
    end
  end
end
