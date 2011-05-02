require 'spec_helper'

describe Address do
  before :each do
    @address = Factory.build(:address)
  end

  it "requires first line to be valid" do
    @address.line_1 = ""
    @address.should_not be_valid
    @address.errors[:line_1].should_not be_empty
  end

  it "requires city to be valid" do
    @address.city = ""
    @address.should_not be_valid
    @address.errors[:city].should_not be_empty
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
