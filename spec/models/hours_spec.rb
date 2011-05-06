require 'spec_helper'

describe Hours do
  before :each do
    @hours = Factory.create(:hours)
  end
  
  it "displays nicely" do
    @hours.to_s.should == '9:00 am - 5:30 pm'
  end

  it "is closed if there is no open hour" do
    @hours.open_hour = nil
    @hours.to_s.should == 'Closed'
  end

  it "is programatically closed if there is no open hour" do
    @hours.open_hour = nil
    @hours.closed?
  end

  it "sets hours to closed if flag is present" do
    @hours.update_attributes(:open_hour => 10, :set_closed => '1')
    @hours.should be_closed
  end
end
