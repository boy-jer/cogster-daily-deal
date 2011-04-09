Given /^I am logged in(.*)$/ do |type_string|
  type = (type_string.split.last || 'user').to_sym
  @user = Factory(type)
  @user.confirm!
  visit "login"
  fill_in "Email", :with => @user.email
  fill_in "Password", :with => @user.password
  click_button "Sign In"
end

Given /^a business "(.*)" has an active project$/ do |business_name|
  @business = Factory(:business, :name => business_name)
  @project = Factory(:project, :business => @business)
end

Then /^I (do not )?see a "(.*)" button$/ do |negative, text|
  if negative
    page.should_not have_button(text)
  else
    page.should have_button(text)
  end
end

Then /^I see a "(.*)" link$/ do |text|
  page.should have_link(text)
end

