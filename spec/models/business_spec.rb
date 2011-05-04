require 'spec_helper'

describe Business do

  it { should have_errors_on(:name) }
  it { should have_errors_on(:community_id) }

  before :each do
    @business = Factory.build(:business, :merchant_id => 1)
  end

  it "validates uniqueness of name" do
    @business.save
    Business.new(@business.attributes).should validate_uniqueness_of(:name).scoped_to(:community_id)
  end

  it "always has current project" do
    @business.current_project.should_not be_nil
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

  describe "#destroy" do
    before :each do
      @business = Business.new
      @business.merchant = Factory(:merchant, :business => nil)
    end

    it "goes quietly if no reason is given" do
      @business.save
      @business.destroy
      unread_emails_for(@business.merchant.email).should have(0).messages
    end

    it "sends message to wannabe merchant if Cogster rejects" do
      @business.save
      @business.deletion_explanation = "text"
      @business.destroy
      unread_emails_for(@business.merchant.email).should have(1).message
    end
  end
end
