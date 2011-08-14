Given /^the project has a maximum purchase of \$50$/ do
  @business.current_project.amount.should == 50
end

Given /^the project funding is \$20 less than the project goal$/ do
  @business.current_project.update_attribute(:goal, 20)
end

Given /^the project funding is equal to the project goal$/ do
  @business.current_project.update_attribute(:goal, 0)
end

Then /^I do not see a way to make a purchase$/ do
  page.should_not have_selector('a', :text => "Double Your Money")
end

Then /^I see a message that says the project has met its goal$/ do
  page.should have_selector('span', :text => "We did it!")
end

Then /^I see( both of)? my purchase(s)? reflected in the project funding$/ do |skip, skip_again|
  page.should have_selector('#funding', :text => "$#{@user.purchases.sum(:amount).to_i}")
end

Then /^I see( one of)? my purchase(s)? reflected in the project's number of supporters$/ do |skip, skip_again|
  page.should have_selector('#supporters', :text => '1')
end
