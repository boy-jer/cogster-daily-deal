Given /^there are 25 merchants in the community$/ do
  @community = Factory(:community)
  opt = BusinessOption.create(:category => "generic")
  25.times{|n| Factory(:business, :community => @community, :business_option => opt, :address => nil, :name => "Biz #{n}", :active => true)}
end

Given /^15 of them are restaurants$/ do
  @opt = Factory(:business_option)
  Business.all.each_with_index do |business,i|
    if i % 5 < 3
      business.update_attribute(:business_option_id, @opt.id)
    end
  end
  Business.count(:conditions => ['business_option_id = ?', @opt]).should == 15
end

Given /^13 of them have the word "Pizza" in their names$/ do
  Business.all.each_with_index do |business,i|
    if i.even?
      business.update_attribute(:name, "Pizza Place #{i}")
    end
  end
end

Given /^1 merchant from another community is a pizza restaurant$/ do
  @other_community = Factory(:community, :name => "Shelbyville")
  @other_business = Factory(:business, :community => @other_community, :business_option => @opt, :name => "Shelbyville Pizza", :active => true)
end

Then /^I see (\d+) merchants$/ do |n|
  page.should have_selector(".business", :count => n.to_i)
end

Then /^I see the next 10 merchants$/ do
  page.should have_selector(".business", :count => 10)
  business = Business.offset(11)
  page.should have_content(business.name)
end

Then /^I see a link to the third page of merchants$/ do
  page.should have_selector("a", :text => /Next/)
end

Then /^I do not see a link to a third page$/ do
  page.should_not have_selector("a", :text => /Next/)
end
