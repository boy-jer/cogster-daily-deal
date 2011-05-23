When /^I upload a logo$/ do
  attach_file('Logo', "#{Rails.root}/features/fixtures/logo.png")
  click_button 'Upload'
end

Then /^I see my logo$/ do
  page.should have_xpath("//div[@class='project_details']//img[contains(@src, 'logo.png')]")
end

When /^I set my business hours$/ do
  check "business_hours_attributes_0_set_closed"
  0.upto(6) do |n|
    select "9", :from => "business[hours_attributes][#{n}][open_hour]"
    select "00", :from => "business[hours_attributes][#{n}][open_minute]"
    select "am", :from => "business[hours_attributes][#{n}][open_meridian]"
    select "5", :from => "business[hours_attributes][#{n}][close_hour]"
    select "00", :from => "business[hours_attributes][#{n}][close_minute]"
    select "pm", :from => "business[hours_attributes][#{n}][close_meridian]"
  end
  check "business_hours_attributes_6_set_closed"
  select "Illinois", :from => "State"
  click_button 'Update'
end

Then /^I see my hours of operation$/ do
  page.should have_selector("dd.Sunday", :text => "Closed")
  page.should have_selector("dd.Monday", :text => "9:00 am - 5:00 pm")
end

When /^I screw up the business hours$/ do
  check "business_hours_attributes_0_set_closed"
  select "9", :from => "business[hours_attributes][1][open_hour]"
  select "00", :from => "business[hours_attributes][1][open_minute]"
  select "pm", :from => "business[hours_attributes][1][open_meridian]"
  select "5", :from => "business[hours_attributes][1][close_hour]"
  select "00", :from => "business[hours_attributes][1][close_minute]"
  select "pm", :from => "business[hours_attributes][1][close_meridian]"
  click_button 'Update'
end

Then /^I see the days are closed$/ do
  page.should have_selector("#business_hours_attributes_0_set_closed", :value => "1")
end
    
