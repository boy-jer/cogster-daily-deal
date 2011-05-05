Given /^someone has requested his community be added$/ do
  @community_request = Factory(:community_request)
end

Then /^I see a reminder of the community request$/ do
  page.should have_selector('h2', :text => "Community Requests")
end

Then /^I see a link to evaluate the community request$/ do
  page.should have_selector('a.community_request')
end

When /^I follow the link to evaluate the community request$/ do
  When "I go to the new community page"
end

Then /^I see the user's description of the community$/ do
  page.should have_selector('dt', :text => "Request Description")
end

Then /^I see the form to create a community$/ do
  page.should have_xpath("//input[@value='Add Community']")
end

Then /^I see a field to mail a response to the user$/ do
  page.should have_selector('label', :text => "Positive Response to Request")
  page.should have_selector('label', :text => "Negative Response to Request")
end

Given /^I want to look at the communities$/ do
  opt = Factory.create(:business_option)
  4.times do |n|
    c = Factory.create(:community, :name => "community #{n}")
    5.times do |m|
      Factory.create(:business, :community => c, :business_option => opt, :name => "business #{n * 10 + m}")
    end
  end
  Factory.create(:community_request)
end
Then /^I see all the communities in Cogster$/ do
  page.should have_selector('h2', :text => "Communities")
  page.should have_selector('tbody tr', :count => Community.count)
end

Then /^I see how many businesses are in each community$/ do
  Community.all.each do |c|
    page.should have_selector('td.business_count', :text => c.businesses.count.to_s)
  end
end

Then /^I see how many users are in each community$/ do
  Community.all.each do |c|
    page.should have_selector('td.user_count', :text => c.users.count.to_s)
  end
end

Then /^I see a link to edit each community$/ do
  page.should have_selector('a', :text => "Edit", :count => Community.count)
end

Then /^I see a button to delete each community$/ do
  page.should have_xpath("//input[@value='Delete']", :count => Community.count)
end
