require 'spec_helper'

describe Project do
  before :each do
    @project = Factory(:project)
  end

  describe "#accepting_purchases?" do
    it "true if funding is less than goal" do
      @project.should_receive(:amount_funded) { @project.goal - 1 }
      @project.should be_accepting_purchases
    end

    it "false if funding equals goal" do
      @project.should_receive(:amount_funded) { @project.goal }
      @project.should_not be_accepting_purchases
    end
  end

  it "sums its purchase amounts" do
    @project.purchases.should_receive(:sum).with('amount').and_return :sum
    @project.amount_funded.should == :sum
  end

  describe "max for user" do
    let(:user) { mock_model(User) }

    it "exists without a user" do
      @project.max_for.should == @project.max_amount
    end

    it "equals max amount if user has no prior purchases in project" do
      user.should_receive(:purchases_of).with(@project).and_return 0
      @project.max_for(user).should == @project.max_amount
    end

    it "is reduced by amount of user's prior purchases in project" do
      user.should_receive(:purchases_of).with(@project).and_return 10
      @project.max_for(user).should == @project.max_amount - 10
    end

    it "is reduced to prevent a purchase which exceeds the goal of the project" do
      user.should_receive(:purchases_of).with(@project).and_return 0
      @project.stub(:amount_funded).and_return @project.goal - 30
      @project.max_for(user).should == 30
    end
  end

  it "automatically sets a min amount" do
    Project.new.min_amount.should == 10
  end

  describe "percent funding" do
    it "is 0 if goal has not been set" do
      Project.new.percent_funded.should == 0
    end

    it "is calculated based on project funding" do
      @project.should_receive(:amount_funded).and_return @project.goal / 2.0
      @project.percent_funded.should be_within(0.1).of(50)
    end
  end

  it "sets min redemption amount per redemption period" do
    product = @project.min_amount * @project.redemption_percentage(1)
    @project.min_redemption_amount(1).should == product
  end

  it "passes redemption percentage to project option" do
    @project.project_option.should_receive(:redemption_percentage).with(1).and_return :result
    @project.redemption_percentage(1).should == :result
  end

  it "sets allowable purchase increments for a user" do
    user = mock_model(User)
    @project.should_receive(:max_for).with(user).and_return 50
    @project.steps_for(user).to_a.should == [10, 20, 30, 40, 50]
  end
end
