require 'spec_helper'

describe BusinessOption do
  before :each do
    BusinessOption.create!(:category => "Restaurants")
  end

  it { should validate_uniqueness_of(:category) }
  it { should validate_presence_of(:category) }
end
