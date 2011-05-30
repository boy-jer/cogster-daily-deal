Then /^I see my swag rating based on my purchases$/ do
  page.should have_selector('#swag a', :text => @user.swag_rank.to_s)
end

Then /^I see a change to the swag meter for the community$/ do
  page.should have_content('$120') 
end

Then /^I see my name at the top of the Our Cogs list$/ do
  page.should have_selector('.top_cogs li div.name', :text => @user.abbr_name)
end

Then /^I see the number of project supporters$/ do
  page.should have_selector('#supporters', :text => @business.supporters.count.to_s)
end
