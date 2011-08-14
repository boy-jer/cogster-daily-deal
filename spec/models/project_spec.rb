require 'spec_helper'

describe Project do
  
  it { should have_errors_on(:goal) }
  it { should have_errors_on(:name) }
  it { should have_errors_on(:business_id) }
  it { should have_errors_on(:amount) }
  it { should have_errors_on(:project_option_id) }

  before :each do
    @project = Factory(:project)
  end

  describe "#accepting_purchases?" do
    it "true if funding is less than goal" do
      @project.should_receive(:funded) { @project.goal - 1 }
      @project.should be_accepting_purchases
    end

    it "false if funding equals goal" do
      @project.should_receive(:funded) { @project.goal }
      @project.should_not be_accepting_purchases
    end
  end

  describe "max for user" do
    let(:user) { mock_model(User) }

    it "exists without a user" do
      @project.max_for.should == @project.amount
    end

    it "equals amount if user has no prior purchases in project" do
      user.should_receive(:purchases_of).with(@project).and_return 0
      @project.max_for(user).should == @project.amount
    end

    it "is reduced by amount of user's prior purchases in project" do
      user.should_receive(:purchases_of).with(@project).and_return 10
      @project.max_for(user).should == @project.amount - 10
    end

    it "is reduced to prevent a purchase which exceeds the goal of the project" do
      user.should_receive(:purchases_of).with(@project).and_return 0
      @project.stub(:funded).and_return @project.goal - 30
      @project.max_for(user).should == 30
    end
  end

  describe "percent funding" do
    it "is 0 if goal has not been set" do
      Project.new.percent_funded.should == 0
    end

    it "is calculated based on project funding" do
      @project.should_receive(:funded).and_return @project.goal / 2.0
      @project.percent_funded.should be_within(0.1).of(50)
    end
  end

  it "sets min redemption amount per redemption period" do
    product = @project.amount * @project.redemption_percentage(1)
    @project.min_redemption_amount(1).should == product
  end

  it "passes redemption percentage to project option" do
    @project.project_option.should_receive(:redemption_percentage).with(1).and_return :result
    @project.redemption_percentage(1).should == :result
  end

  it "sorts purchases by user name and creation date" do
    date = Date.today
    p = [mock_model(Purchase, :abbr_name => 'Joe X', :created_at => date),
         mock_model(Purchase, :abbr_name => 'Joe Y', :created_at => date),
         mock_model(Purchase, :abbr_name => 'Joe X', :created_at => date - 1)]
    
  end
  it "selects 5 top supporters based on total purchases and user signup" do
    time = Time.now
    best = mock_model(User, :id => 1, :created_at => time)
    late = mock_model(User, :id => 2, :created_at => time)
    early = mock_model(User, :id => 3, :created_at => time - 100)
    cheap = mock_model(User, :id => 4, :created_at => time)
    other = mock_model(User, :id => 6, :created_at => time - 100)
    extra = mock_model(User, :id => 5, :created_at => time)
    @project.should_receive(:supporters) { [extra, other, cheap, early, late, best]}
    purchases = [mock_model(Purchase, :user_id => 2, :amount => 10),
                 mock_model(Purchase, :user_id => 3, :amount => 10),
                 mock_model(Purchase, :user_id => 1, :amount => 9),
                 mock_model(Purchase, :user_id => 1, :amount => 9),
                 mock_model(Purchase, :user_id => 4, :amount => 5)]
    @project.stub(:purchases) { purchases }
    @project.top_supporters.should == [best, early, late, cheap, other]
  end

  it "increments its funding and community impact" do
    @project.should_receive(:save!)
    @project.should_receive(:community).and_return community = mock_model(Community)
    community.should_receive(:increment!).with(:impact, 30)
    @project.send(:increment_self_and_community!, 10)
    @project.funded.should == 10
  end
end
