Given /^I don't have a merchant account$/ do
  User.destroy_all
  Factory.create(:community)
  Factory.create(:community, :name => "The Grove")
end

Then /^I get a merchant account$/ do
  User.count(:conditions => "role = 'merchant'").should == 1
end

Given /^I have a merchant account$/ do
  @user = Factory.create(:merchant)
end

When /^I enter my login information$/ do
  visit "login"
  fill_in "Email", :with => @user.email
  fill_in "Password", :with => @user.password
  click_button "Sign In"
end

When /^I ask for a new password$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should get an email with the new password$/ do
  
end

Then /^the old password should no longer work$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should be able to log in with the new password$/ do
  pending # express the regexp above with the code you wish you had
end  
