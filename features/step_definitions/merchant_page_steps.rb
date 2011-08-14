Given /^I do not have a project$/ do
  @user.business.projects.count.should == 0
  Factory.create(:project_option)
end

Then /^I see a link to create a project$/ do
  page.should have_selector('#new_project')
end

Then /^I (do not )?see details of my current project$/ do |negate|
  if negate
    page.should_not have_selector('#project_status')
  else
    page.should have_selector('#project_status')
  end
end

When /^I create a project$/ do
  fill_in "Name", :with => "New Pac-Man"
  fill_in "Goal", :with => "300"
  fill_in "Description", :with => "Because everybody loves Pac-Man"
  select "50", :from => "Purchase Amount"
  select ProjectOption.first.description.to_s, :from => "Timetable"
  check "project_terms"
  click_button "Create"
end
When /^I visit my account home page$/ do
  visit('/account')
end
