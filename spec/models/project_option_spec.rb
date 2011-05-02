require 'spec_helper'

describe ProjectOption do
  before do
    @project_option = Factory.build(:project_option)
  end

  it "is invalid if total return < 100%" do
    @project_option.redemption_schedule = [ { :duration => 7, :percentage => 50 },
                                      { :duration => 7, :percentage => 49 }]
    @project_option.should_not be_valid
    @project_option.errors[:base].should_not be_empty
  end

  it "is valid with total return > 100%" do
    @project_option.redemption_schedule = [ { :duration => 7, :percentage => 50 },
                                      { :duration => 7, :percentage => 51 }]
    @project_option.should be_valid
  end
  
  def duplicate_has_errors_on(field)
    @project_option.save
    duplicate = Factory.build(:project_option)
    duplicate.should_not be_valid
    duplicate.errors[field].should_not be_empty
  end

  it "requires unique description" do
    duplicate_has_errors_on(:description)
  end

  it "requires unique redemption schedule" do
    duplicate_has_errors_on(:redemption_schedule)
  end

  it "extracts redemption duration from schedule" do
    default_schedule =  [ { :duration => 7, :percentage => 50 },
                          { :duration => 7, :percentage => 50 },
                          { :duration => 7, :percentage => 50 },
                          { :duration => 7, :percentage => 50 } ]
    @project_option.redemption_schedule.should == default_schedule
    @project_option.duration.should == 28
  end

  it "has default 4 week duration" do
    project_option = ProjectOption.with_redemption_schedule
    project_option.duration.should == 28
  end
end
