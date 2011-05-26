Given /^a region named "([^\"]*)"$/ do |name|
  @community = Community.create(:name => name)
end

Given /^I am not logged in$/ do
  true
end

Then /^I should see a list of communities$/ do
  page.has_css?("#region_listing > ul")
end

When /^I choose a community$/ do
  click_link @community.name
end

Then /^I should be taken to the community page$/ do
  visit community_path(@community)
end

When /^I want a community that isn't listed$/ do
  click_link "Don't see your community?"
end

Then /^I should be taken to a form to request a community$/ do
  visit "community_requests/new"
end

Given /^I don't have a user account$/ do
  true
end

When /^I register( and confirm)?( as a merchant)?$/ do |confirm, merchant|
  visit merchant.blank?? "register" : "register?business=true"
  fill_in "First Name", :with => "Steve"
  fill_in "Last Name", :with => "Bisbee"
  fill_in "Email", :with => "steve@cogster.com"
  fill_in "Password", :with => "password"
  fill_in "Confirm Password", :with => "password"
  unless merchant.blank?
    fill_in "Name", :with => "BJ's"
    fill_in "Description", :with => "Where The Grove Eats"
  end
  click_button "Sign Up"
  if confirm
    User.last.confirm! 
    User.last.increment!(:sign_in_count)
  end
end

Then /^I should get a user account$/ do
  User.find_by_first_name("Steve").last_name.should == "Bisbee"
end

Then /^I should be taken to the home page for my account$/ do
  visit "/"
end

When /^I log in/ do
  User.find_by_email("steve@cogster.com").increment!(:sign_in_count)
  visit "login"
  fill_in "Email", :with => "steve@cogster.com"
  fill_in "Password", :with => "password"
  click_button "Sign In"
end

When /^I choose a new password$/ do
  fill_in "New Password", :with => "new_password"
  fill_in "Confirm Password", :with => "new_password"
  click_button "Update"
end

When /^I ask for a new password$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should get an email with the new password$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^the old password should no longer work$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should be able to log in with the new password$/ do
  pending # express the regexp above with the code you wish you had
end

