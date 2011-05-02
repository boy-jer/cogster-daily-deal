Given /^I do not have a project$/ do
  @user.business.projects.count.should == 0
  Factory.create(:project_option)
end

Then /^I see a link to create a project$/ do
  page.should have_selector('#new_project')
end

Then /^I (do not )?see details of my current project$/ do |negate|
  if negate
    page.should_not have_selector('.progress')
  else
    page.should have_selector('.progress')
  end
end

When /^I create a project$/ do
  fill_in "Name", :with => "New Pac-Man"
  fill_in "Goal", :with => "300"
  fill_in "Target Completion Date", :with => Date.today + 30
  fill_in "Description", :with => "Because everybody loves Pac-Man"
  select "50", :from => "Maximum Individual Purchase"
  select ProjectOption.first.description.to_s, :from => "Timetable"
  check "project_terms"
  click_button "Create"
end
When /^I visit my account home page$/ do
  visit('/account')
end

Then /^I should see details of my current project$/ do
  page.should have_selector('.business h4', :text => @user.business.name)
end

Then /^I should see a link to start a new project$/ do
end
