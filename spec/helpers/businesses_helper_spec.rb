require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the BusinessesHelper. For example:
#
# describe BusinessesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe BusinessesHelper do
  describe "#community_name" do
    it "returns nil if businesses are from multiple communities" do
      biz = mock_model(Business, :community_id => 1)
      other_biz = mock_model(Business, :community_id => 2)
      assign(:businesses, [biz, other_biz])
      helper.community_name.should be_nil
    end

    it "returns the name of the businesses' community if they are all from the same place" do
      businesses = Array.new(10){|b| mock_model(Business, :community_id => 1, :community_name => 'The Grove')}
      assign(:businesses, businesses)
      helper.community_name.should == 'The Grove'
    end
  end

  describe "#none_like" do
    it "mentions the search term if there was one" do
      helper.stub(:params).and_return({ :search => 'Meaning' }) 
      helper.none_like.should match(/Meaning/)
    end

    it "has generic text if there was a filter" do
      helper.stub(:params).and_return({ :filter => 'Restaurants' }) 
      helper.none_like.should_not be_empty
    end

    it "is blank if neither of those params are present" do
      helper.stub(:params).and_return({}) 
      helper.none_like.should be_nil
    end
  end
end
