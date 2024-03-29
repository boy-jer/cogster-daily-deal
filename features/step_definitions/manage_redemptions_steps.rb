Given /^a user has Cogster cash that can be reimbursed this week$/ do
  Given "I am logged in"
  @cogster = @user
  Given "I have made a purchase"
  click_button 'Log out'
end

Given /^I am a fucking merchant$/ do
  visit "login"
  fill_in "Email", :with => @merchant.email
  fill_in "Password", :with => @merchant.password
  click_button "Sign In"
end

Given /^I am a merchant with an active project$/ do
  @merchant = Factory.create(:merchant)
  @merchant.confirm! unless @merchant.confirmed?
  @business = @merchant.business
  @project = Factory.create(:project, :business => @business)
end

When /^I click the pdf link "([^\"]*)"$/ do |text|
  click_link text
  temp_pdf = Tempfile.new('pdf')
  temp_pdf.puts page.body.force_encoding("UTF-8")
  temp_pdf.close
  temp_txt = Tempfile.new('txt')
  temp_txt.close
  `pdftotext -enc UTF-8 #{temp_pdf.path} #{temp_txt.path}`
  page.driver.instance_variable_set('@body', File.read(temp_txt.path))
end

Then /^I see a Cogster cash table$/ do
  page.should have_selector('table#redemptions')
end

Then /^I see a row with the user's name and Cogster ID$/ do
  page.should have_selector('td', :text => @cogster.abbr_name)
  page.should have_selector('td', :text => @cogster.cogster_id)
end

Then /^I see how much Cogster cash the user has available$/ do
  amount = @cogster.purchases.first.current_coupon.amount.to_i
  page.should have_selector('td a', :text => "$#{amount}.00")
end

When /^I click the amount$/ do
  amount = @cogster.purchases.first.current_coupon.amount.to_i
  click_link "$#{amount}.00"
end

Then /^I see a form to redeem the user's Cogster cash$/ do
  page.should have_selector('h2', :text => "Redeem Coupon")
end

Then /^I see a table of every purchase made in my active project$/ do
  #page.should have_selector('tbody tr', :count => @project.purchases.count)
end

Then /^each row has the purchaser's name$/ do
  @project.purchases.each do |purchase|
    #page.should have_selector('td', :text => purchase.user.abbr_name)
    page.should have_content purchase.user.abbr_name
  end
end

Then /^each row has the date of purchase$/ do
  @project.purchases.each do |purchase|
    #page.should have_selector('td', :text => purchase.created_at.strftime("%B %d"))
    page.should have_content purchase.created_at.strftime("%B %d")
  end
end

Then /^each row has the purchase amount$/ do
  @project.purchases.each do |purchase|
    #page.should have_selector('td', :text => "$#{purchase.amount.to_i}.00")
    page.should have_content "$#{purchase.amount.to_i}.00"
  end
end

Then /^each row has the Cogster cash value for each redemption period$/ do
  @project.purchases.each do |purchase|
    purchase.coupons.each do |coupon|
      #page.should have_selector('td', :text => "$#{coupon.amount.to_i}.00")
      page.should have_content "$#{coupon.amount.to_i}.00"
    end
  end
end
