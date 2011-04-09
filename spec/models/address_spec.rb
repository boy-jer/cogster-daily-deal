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
end
