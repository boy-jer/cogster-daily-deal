Given /^a user has Cogster cash that can be reimbursed this week$/ do
  @cogster = Factory.create(:user, :community => Community.first)
  purchase = @cogster.purchases.build(:project => @project, :amount => 20)
  purchase.type = 'master'
  purchase.save
end

Given /^I have an active project$/ do
  @project = Factory.create(:project, :business => @user.business)
end

Then /^I see a Cogster cash table$/ do
  page.should have_selector('table#redemptions')
end

Then /^I see a row with the user's name and Cogster ID$/ do
  page.should have_selector('td', :text => @cogster.abbr_name)
  page.should have_selector('td', :text => @cogster.cogster_id)
end

Then /^I see how much Cogster cash the user has available$/ do
  amount = @cogster.purchases.first.current_coupon.remainder.to_i
  page.should have_selector('td a', :text => "$#{amount}.00")
end

When /^I click the amount$/ do
  amount = @cogster.purchases.first.current_coupon.remainder.to_i
  click_link "$#{amount}.00"
end

Then /^I see a form to redeem the user's Cogster cash$/ do
  page.should have_selector('h2', :text => "Redeem Coupon")
end

Given /^a user has Cogster cash that expires midweek$/ do
  desired_date = Date.today - Date.today.wday - 10
  Timecop.freeze(desired_date) do
    @cogster = Factory.create(:user, :community => Community.first)
    purchase = @cogster.purchases.build(:project => @project, :amount => 20)
    purchase.type = 'master'
    purchase.save
  end
end

Given /^the user has Cogster cash that becomes available midweek$/ do
  @cogster.purchases.first.coupons.first.good_during_week_of?(Date.today)
  @cogster.purchases.first.coupons.second.good_during_week_of?(Date.today)
end

Then /^I see which days are in the user's first redemption period$/ do
  page.should have_xpath('//td[@colspan="4"]/a')
end

Then /^I see which days are in the user's second redemption period$/ do
  page.should have_xpath('//td[@colspan="3"]/a')
end

Then /^I see a table of every purchase made in my active project$/ do
  page.should have_selector('tbody tr', :count => @project.purchases.count)
end

Then /^each row has the purchaser's name$/ do
  @project.purchases.each do |purchase|
    page.should have_selector('td', :text => purchase.user.abbr_name)
  end
end

Then /^each row has the date of purchase$/ do
  @project.purchases.each do |purchase|
    page.should have_selector('td', :text => purchase.created_at.strftime("%B %d"))
  end
end

Then /^each row has the purchase amount$/ do
  @project.purchases.each do |purchase|
    page.should have_selector('td', :text => "$#{purchase.amount.to_i}.00")
  end
end

Then /^each row has the Cogster cash outstanding for each redemption period$/ do
  @project.purchases.each do |purchase|
    purchase.coupons.each do |coupon|
      page.should have_selector('td', :text => "$#{coupon.remainder.to_i}.00")
    end
  end
end
