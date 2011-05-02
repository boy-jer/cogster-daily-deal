Given /^someone has signed up and said he has a business$/ do
  @user = Factory.create(:merchant)
  @user.business.update_attribute(:active, false)
end

Then /^I see a reminder of the business request$/ do
  page.should have_selector('h2', :text => "Business Requests")
end

Then /^I see a link to edit the business request$/ do
  page.should have_selector('.business_request td a', :text => Business.first.name)
end

When /^I visit the edit page for the merchant/ do
  When "I click \"Users\""
  When "I click \"Merchants\""
  When "I click \"#{User.merchant.first.name}\""
end

Then /^I see a form to describe the user's business$/ do
  page.should have_selector('label', :text => "Description")
end


Then /^I see a select box to mark the user as customer or merchant or admin$/ do
  page.should have_selector('select#user_role')
end

Then /^I see a notice that the new account was created$/ do
  page.should have_selector('#notice')
end

Then /^I see a form to enter user details$/ do
  page.should have_selector('form#new_user')
end

When /^I visit the "New User" page$/ do
  When "I click \"Users\""
  When "I click \"Add User\""
end

When /^I fill out the user form$/ do
  fill_in "First Name", :with => "New"
  fill_in "Last Name", :with => "Guy"
  fill_in "Email", :with => "newguy@test.com"
  fill_in "Password", :with => "password"
  fill_in "Confirm Password", :with  => "password"
  select "admin", :from => "Role"
  click_button "Create"
end

Given /^there are a lot of users$/ do
  community = Community.first
  11.times do |n|
    Factory.create(:user, :email => "user#{n}@example.com", :community => community)
  end
end

Then /^I see the first ten users$/ do
  page.should have_selector('tr.cogster', :count => 10)
end

Then /^I see a link to reach the next page of users$/ do
  page.should have_selector('a.next_page')
end
