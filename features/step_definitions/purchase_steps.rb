Then /^I see how much Cogster Cash I (will|would) get over time if I (make|made) a purchase$/ do |ignore, also_ignore|
  page.should have_selector('#purchase_values_table')
end

When /^I make a purchase for the "(.*)" project$/ do |business_name|
  visit business_purchase_path(@business)
  save_and_open_page
  click_button "Purchase"
end
