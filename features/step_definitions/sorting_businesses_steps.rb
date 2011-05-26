Given /^the following businesses:$/ do |table|
  opt = Factory(:project_option)
  table.hashes.map do |hash|
    community = Community.find_or_create_by_name(hash['Community'])
    type = BusinessOption.find_or_create_by_category(hash['Type'])
    business = Business.create!(:name => hash['Name'], 
                                :featured => hash['Featured'],
                                :community => community,
                                :business_option => type,
                                :active => true)
    unless hash['Goal'] == '0'
      attr = { :goal => hash['Goal'], :funded => hash['Funded'], 
             :project_option => opt }
      business.projects.create!(Factory.attributes_for(:project).merge(attr))
    end
  end
end

Then /^the merchant in position (\d+) is (.*)$/ do |n, name|
  page.should have_selector('#businesses') do |container|
    container[0].should have_selector('.business') do |div|
      div[n - 1].should have_selector('h4 a', :text => name)
    end
  end
end

Then /^it all works$/ do
  Community.count.should == 5
  Business.count.should == 23
  Project.count.should == 22
  Community.find_by_name("Grove").businesses.count.should == 13

end

Then /^I should be a Grove person$/ do
  User.count.should == 1
  @user = User.first
  @user.community.name.should == 'Grove'
  @community = @user.community
  @user.confirm!
end
