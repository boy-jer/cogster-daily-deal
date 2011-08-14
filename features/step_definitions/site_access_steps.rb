Given /^I don't have a(n| merchant) account$/ do |skip|
  User.destroy_all
  Factory.create(:community)
  Factory.create(:community, :name => "The Grove")
end

Then /^I get a merchant account$/ do
  User.count(:conditions => "role = 'merchant'").should == 1
end

Given /^I have a merchant account$/ do
  @user = Factory.create(:merchant)
  @user.increment!(:sign_in_count)
end

When /^I enter my login information$/ do
  visit "login"
  fill_in "Email", :with => @user.email
  fill_in "Password", :with => @user.password
  click_button "Sign In"
end

Then /^I receive an email to confirm$/ do
  @user = User.first
  unread_emails_for(@user.email).size.should == 1
end

When /^I open the confirmation email$/ do
  open_email(@user.email)
end

Then /^I see the confirmation link$/ do
  Then "I should see \"users/confirmation?confirmation_token=#{@user.confirmation_token}\" in the email body"
end

When /^I follow the confirmation link$/ do
  visit_in_email("users/confirmation?confirmation_token=#{@user.confirmation_token}")
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

Then /^I take a look-see$/ do
  save_and_open_page
end
