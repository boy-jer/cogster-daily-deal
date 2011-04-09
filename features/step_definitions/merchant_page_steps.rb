Given /^I have a merchant account$/ do |args|
  Merchant.create!(:email => "fake@example.com", :first_name => "Steve", :last_name => "Bisbee")
end

When /^I visit my account home page$/ do
  visit('/account')
end

