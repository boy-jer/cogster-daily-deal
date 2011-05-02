Then /^I see how much Cogster Cash I (will|would) get over time if I (make|made) a purchase$/ do |ignore, also_ignore|
  page.should have_selector('#purchase_values_table')
end

Then /^I get (a|two) purchase confirmation email(s)?$/ do |n, ignore|
  n = n == 'two' ? 2 : 1
  Purchase.count.should == n
  unread_emails_for(@user.email).should have(n).message
end

Then /^I see a notice about how much Cogster Cash I have available$/ do
  page.should have_selector('#notice')
end

Then /^I should see a list of all the purchases I have made$/ do
  page.should have_selector('.business', :count => @user.purchases.size)
end

Then /^I should see links to print Cogster Cash for any current spending periods$/ do
  page.should have_selector('a', :text => "Print Cash", :count => @user.purchases.size)
end

Given /^I have Cogster Cash for a business available today$/ do
  Given "I make a purchase for the \"#{@business.name}\" project"
  @user.purchases.first.current_coupon.should_not be_nil
end

When /^I visit my Cogster Cash page for that business$/ do 
  When "I go to the account page"
  click_link "Print Cash"
end

Then /^I get a pdf$/ do
  page.response_headers['Content-Type'].should == "application/pdf"
end

Then /^I see a Cogster Cash coupon$/ do
  #this is a hack - get the coupon as html so capybara can inspect it,
  #and assume the content is the same in the pdf
  visit cash_path(@user.purchases.first)
  page.should have_selector('h4', :text => "Cogster Cash")
end
  
Then /^I see how much money I have available$/ do
  page.should have_selector('#value', :text => "$#{@user.purchases.first.current_coupon.remainder.to_i}.00")
end

Then /^I see the duration of the spending period$/ do
  page.should have_selector('#start_date')
  page.should have_selector('#end_date')
end

Then /^I see what business the coupon is for$/ do
  page.should have_selector('#business strong', :text => @business.name)
end

Then /^I see a unique identifier for myself$/ do
  page.should have_selector('#unique_id span', :text => @user.cogster_id)
end

Then /^I see the community$/ do
  page.should have_selector('#region', :text => @business.community.name)
end
