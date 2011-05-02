Given /^there are project options in the system$/ do
  Factory.create(:project_option)
end

Then /^I see all the project options in Cogster$/ do
  ProjectOption.all.each do |p|
    page.should have_selector("tbody tr#project_option_#{p.id} td", :text => p.description)
  end
end

Then /^I see how many active projects are using each option$/ do
  ProjectOption.all.each do |p|
    page.should have_selector("tbody tr#project_option_#{p.id} td a", :text => p.projects.active.count.to_s)
  end
end

Then /^I see a link to edit each project option$/ do
  ProjectOption.all.each do |p|
    page.should have_selector("tbody tr#project_option_#{p.id} td a", :text => "Edit")
  end
end

Then /^I see a button to delete any project option$/ do
  ProjectOption.all.each do |p|
    page.should have_xpath("//tr[@id='project_option_#{p.id}']//input[@value='delete']")
  end
end

When /^I visit the "Add New Project Option" page$/ do
  When "I go to the account page"
  When "I click \"Project Options\""
  When "I click \"Add New Project Option\""
end

Then /^I see a form to enter a description for the project option$/ do
  page.should have_selector('form#new_project_option')
end

When /^I fill out the project option form$/ do
  fill_in "Description", :with => "cucumber option"
  3.times do |n|
    fill_in "project_option_redemption_schedule_return_#{n}", :with => '75' 
  end
  click_button "Create"
end

Then /^I see the new project option$/ do
  page.should have_selector('td', :text => 'cucumber option')
end
