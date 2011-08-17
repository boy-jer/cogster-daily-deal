Then /^I see my name at the top of the Our Cogs list$/ do
  page.should have_selector('.top_cogs li div.name', :text => @user.abbr_name)
end

Then /^I see the number of project supporters$/ do
  page.should have_selector('#supporters', :text => @business.supporters.count.to_s)
end
