Given /^I am logged in(.*)$/ do |type_string|
  type = (type_string.split.last || 'user').to_sym
  @user = User.find_by_role(type) || Factory(type)
  @user.confirm! unless @user.confirmed?
  visit "login"
  fill_in "Email", :with => @user.email
  fill_in "Password", :with => @user.password
  click_button "Sign In"
end

Given /^I just checked my email$/ do
  reset_mailer
end

Given /^a business "(.*)" has an active project$/ do |business_name|
  category = Factory(:business_option, :category => 'some unique thing')
  @business = Factory(:business, :name => business_name, :business_option => category)
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

When /^I visit my account page$/ do
  When "I go to the account page"
end

When /^I make a (.*?)purchase for the "(.*)" project$/ do |amt, business_name|
  business = Business.find_by_name(business_name)
  visit business_purchase_path(business)
  select amt.to_i.to_s, :from => "purchase_amount" if amt
  select "MasterCard", :from => "Card Type"
  fill_in "Credit Card Number", :with => "5500000000000004"
  fill_in "Security code", :with => "123"
  select Date.today.month.to_s, :from => "purchase_expiration_month"
  select Date.today.year.to_s, :from => "purchase_expiration_year"
  fill_in "Address", :with => "100 Market St"
  fill_in "City", :with => "Selinsgrove"
  select "Pennsylvania", :from => "State"
  fill_in "Zip Code", :with => "17870"
  click_button "Purchase"
end

Given /^I have made two purchases$/ do
  Given "I make a purchase for the \"#{@business.name}\" project"
  Given "I make a purchase for the \"#{@business.name}\" project"
end

Given /^I have made a purchase$/ do
  Given "I make a $40 purchase for the \"#{@business.name}\" project"
end

Then /^I see my swag rating$/ do
  page.should have_selector('.my_swag')
end

Then /^I do not see my current project$/ do
  page.should_not have_selector('.progress_bar_container')
end
