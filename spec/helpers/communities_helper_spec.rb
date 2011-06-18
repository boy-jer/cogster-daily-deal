require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the CommunitiesHelper. For example:
#
# describe CommunitiesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe CommunitiesHelper do
  it "formats the swag rank for a cog" do
    assign(:community, mock_model(Community, :swag_rank => 4.01))
    helper.rating_for(:cog).should == '4.0'
  end
end
