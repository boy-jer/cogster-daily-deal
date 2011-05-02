When /^the first redemption period for the project is two days from expiration$/ do
  desired_date = @user.purchases.first.current_coupon.expiration_date - 2 
  Timecop.freeze(desired_date) do
    Purchase.check_for_expiring_coupons
  end
end

Given /^some of my Cogster cash for the period has not been redeemed$/ do
  @user.purchases.first.current_coupon.remainder.should be > 0
end

Then /^I get an email reminder$/ do
  unread_emails_for(@user.email).should have(1).message
end

Then /^the email says how much Cogster cash I have available for the redemption period$/ do
  Then "I should see \"$#{@user.purchases.first.current_coupon.remainder.to_i}.00\" in the email body"
end

Then /^the email says which business created the project$/ do
  Then "I should see \"#{@user.purchases.first.business.name}\" in the email body"
end

Then /^the email says when the Cogster cash will expire$/ do
  Then "I should see \"#{@user.purchases.first.current_coupon.expiration_date.strftime("%B %d")}\" in the email body"
end

Given /^the first redemption period for the project has expired$/ do
  Timecop.freeze(@user.purchases.first.current_coupon.expiration_date + 1)
end

Then /^I see the Cogster cash available for the second and subsequent redemption periods$/ do
  @user.purchases.first.coupons.each do |coupon|
    next if coupon.expired?
    page.should have_selector("td.balance", :text => "$#{coupon.remainder.to_i}.00") 
  end
end

Then /^I see the Cogster cash for the first redemption period has expired$/ do
  page.should have_selector("tr.expired td", :text => "Expired")
end

Given /^all the Cogster cash for the first redemption period has been redeemed$/ do
  @user.purchases.first.current_coupon.update_attribute(:remainder, 0)
end

Then /^I see the Cogster cash available for future redemption periods$/ do
  @user.purchases.first.coupons.each do |coupon|
    next if coupon.remainder == 0
    page.should have_selector("td.balance", :text => "$#{coupon.remainder.to_i}.00") 
  end
end

Then /^I see the Cogster cash for the first redemption period has a balance 0$/ do
  page.should have_selector("td.balance", :text => "$0.00") 
end
