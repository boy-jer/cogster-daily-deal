Given /^there are several existing project options$/ do
  3.times do |n|
    schedule = Array.new(n + 1){|i| {:duration => 7, :percentage => 200.0 / (n + 1)}}
    Factory.create(:project_option, :description => "#{n + 1} Week",
                   :redemption_schedule => schedule)
  end
end

Then /^I see a list of all the project options$/ do
  page.should have_content("Project Options")
end

Then /^I see links to edit and delete them$/ do
  options = ProjectOption.count
  page.should have_css("#content input[type=\"submit\"][value=\"Delete\"]", :count => options)
end

Then /^I am able to enter a description$/ do
  Then %Q{I see "Description"}
end

Then /^I am able to enter incremental periods$/ do
  Then %Q{I see "Duration"}
  And %Q{I see "Return Rate"}
end

Given /^I have entered valid information on a project option$/ do
  visit edit_admin_project_option_path(ProjectOption.first)
  fill_in "Description", :with => "Valid description"
end

Then /^I submit the "([^"]*)" form$/ do |name|
  click_button name.capitalize
end

Then /^I see the updated information$/ do
  Then %Q{I see "Valid description"}
end

When /^I delete the first project option$/ do
  @option = ProjectOption.first
  page.find('.button').click
end

Then /^I do not see the deleted option$/ do
  page.should_not have_content(@option.description)
end

When /^I enter project option details with description "([^"]*)"$/ do |name|
  fill_in "Description", :with => name
  select '7', :from => "project_option[redemption_schedule_duration][]"
  fill_in "project_option[redemption_schedule_return][]", :with => '100'
end
