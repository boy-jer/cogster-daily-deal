require 'spec_helper'

describe Hours do
  before :each do
    @hours = Factory.create(:hours)
  end
  
  it "displays nicely" do
    @hours.to_s.should == '9:00 am - 5:30 pm'
  end

  it "is shows when it is closed" do
    @hours.closed = true
    @hours.to_s.should == 'Closed'
  end

end
