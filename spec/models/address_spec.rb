require 'spec_helper'

describe Address do

  before :each do
    @address = Factory.build(:address)
  end

  it "puts zip and state on last line if present" do
    @address.last_line.should =~ /#{@address.zip}/
  end

  it "skips zip and state on last line if not present" do
    @address.zip = ""
    @address.state = ""
    @address.last_line.should == @address.city
  end
end
