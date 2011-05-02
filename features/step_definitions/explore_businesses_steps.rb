Given /^there are several businesses active in a community$/ do
  @community = Factory.create(:community)
  restaurant = Factory.create(:business_option)
  apparel = Factory.create(:business_option, :category => "apparel")
  project_option = Factory.create(:project_option)
  scrambled_alpha = %w(c b a d e)
  5.times do |n|
    type = n.odd?? restaurant : apparel
    b = Factory.create(:business, :name => "#{scrambled_alpha[n]}Business #{n}", :community => @community, :active => true, :business_option => type)
    Factory.create(:merchant, :email => "user#{n}@example.com", :business => b, :community => @community)
    Factory.create(:project, :business => b, :project_option => project_option)
  end
end

Then /^I should see the profiles of the businesses in the community$/ do
  page.should have_selector('.business', :count => Business.count)
end
 
Then /^I should see links to the page for each business$/ do
  Business.all.each do |b|
    page.should have_selector('a', :text => b.name)
  end
end

Given /^there is a business named "(.*)"$/ do |name|
  Given "there are several businesses active in a community"
  Factory.create(:business, :name => name, :community => @community, :active => true, :business_option => BusinessOption.first)
end

When /^I search for "(.*)"$/ do |name|
  visit community_path(@community)
  fill_in "search", :with => name
  click_button "Search"
end

Then /^I should see the profile for "(.*)"/ do |name|
  page.should have_selector('.business a', :text => name)
end

Given /^there are restaurants and shops in a community$/ do
  Given "there are several businesses active in a community"
end

Then /^I should see the profiles for the restaurants$/ do
  page.should have_selector('h3', :text => "Search for restaurants")
  page.should have_selector('.business', :count => Business.category('restaurants').count)
end

Then /^I should not see the profiles for the shops$/ do
  Business.category('apparel').each do |biz|
    page.should_not have_selector('a', :text => biz.name)
  end
end

Then /^I should see the profiles of the community businesses in alphabetical order$/ do
  save_and_open_page
end
