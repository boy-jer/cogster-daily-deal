# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
ActiveRecord::Base.record_timestamps = false

['Happy Valley', 'Ephrata Area', 'Susquehanna Valley'].each_with_index do |name, i|
  Community.create!(:name => name, :state => 'PA', :active => name == 'Happy Valley', :community_id => i + 1)
end
puts 'communities created'

File.open("#{Rails.root}/db/slim_cogster.sql") do |f|
  lines = f.readlines

  [189, 190].each do |n|
    puts "new address line"
    lines[n].sub(/[^\(]+/,'').split('), (').each do |address_string|
      address_array = address_string.split(/('|null), /)
      Address.create!(:location_id => address_array[0].gsub(/[^\d]/,''), :line_1 => address_array[2].sub(/\'/,''), :line_2 => address_array[4].sub(/\'/,''), :city => address_array[6].sub(/\'/,''), :state => address_array[8].sub(/\'/,''), :zip => address_array[10].sub(/\'/,''), :phone => address_array[12].sub(/\'/,''), :country => address_array[14].sub(/\'/,''))
    end
  end
  puts "#{Address.count} addresses created"

  (300..305).to_a.each do |n|
    lines[n].sub(/[^\(]+/,'').split('), (').each do |user_string|
      user_array = user_string.split(/('|null), /)
      community = Community.find_by_community_id(user_array[38].gsub(/[^\d]/,'')).id
      user = User.new(:user_id => user_array[0].gsub(/[^\d]/,''), :community_id => community, :email => user_array[4].sub(/\'/,''), :first_name => user_array[8].sub(/\'/,''), :last_name => user_array[10].sub(/\'/,''), :role => 'cogster')
      user.password = user.email.downcase
      user.password_confirmation = user.password
      user.address = Address.find_by_location_id(user_array[2].sub(/\'/,''))
      puts "user #{user.password}" unless user.save
      user.confirm! if user.persisted? && user.respond_to?(:confirm!)
    end
  end

  [52, 53].each do |n|
    lines[n].sub(/[^\(]+/,'').split('), (').each do |business_string|
      business_array = business_string.split(/('|null), /)
      community = Community.find_by_community_id(business_array[2].gsub(/[^\d]/,'')).id
      merchant = User.find_by_user_id(business_array[8].gsub(/[^\d]/,''))
      business = Business.new(:business_id => business_array[0].gsub(/[^\d]/,''), :name => business_array[10].sub(/\'/,''), :description => business_array[32].sub(/\'/,'').gsub(/\\/,'')[0..499], :community_id => community, :merchant_id => merchant.id, :active => business_array[36].sub(/\'/,''), :featured => business_array[40].gsub(/\'/,''))
      if merchant
        merchant.update_attribute(:role, 'merchant')
        puts "#{merchant.email} is merchant for #{business.name}"
      else
        puts "no merchant for #{business.name}!"
      end
      option = BusinessOption.find_or_initialize_by_category(business_array[14].sub(/\'/,''))
      business.business_option = option
      if business_array[18].length > 2
        business.build_website(:url => business_array[18].sub(/\'/,''))
      elsif business_array[20].length > 2
        business.build_website(:url => business_array[20].sub(/\'/,''))
      elsif business_array[22].length > 2     
        business.build_website(:url => business_array[22].sub(/\'/,''))
      end
      business.address = Address.find_by_location_id(business_array[4].sub(/\'/,''))
      puts "#{business.name} not saved; #{business.errors.full_messages}" unless business.save
    end
  end
    
  ProjectOption.create!(:description => '3-Month Option (10-5-5)', :active => true, :redemption_schedule => [{ :duration => 30, :percentage => 100}, { :duration => 30, :percentage => 50 }, { :duration => 30, :percentage => 50 }])
  ProjectOption.create!(:description => '8 Week Dividend: Local is worth waiting for.', :active => false, :redemption_schedule => [{ :duration => 7, :percentage => 25 }, { :duration => 7, :percentage => 25 }, { :duration => 7, :percentage => 25 }, { :duration => 7, :percentage => 25 }, { :duration => 7, :percentage => 25 }, { :duration => 7, :percentage => 25 }, { :duration => 7, :percentage => 25 }, { :duration => 7, :percentage => 25 }])
  ProjectOption.create!(:description => '15 Month: Long Term Supporter', :active => false, :redemption_schedule => [{ :duration => 120, :percentage => 0}, { :duration => 30, :percentage => 50 }, { :duration => 30, :percentage => 50 }])
  ProjectOption.create!(:description => 'Community Builder', :active => false, :redemption_schedule => [{ :duration => 120, :percentage => 0}, { :duration => 1, :percentage => 100 }])
  ProjectOption.create!(:description => '90-Day \"50-50-50\" Option', :active => false, :redemption_schedule => [{ :duration => 30, :percentage => 50}, { :duration => 30, :percentage => 50 }, { :duration => 30, :percentage => 50 }])
  ProjectOption.create!(:description => '8-Week \\\"Double Money\\\" Option', :active => false, :redemption_schedule => [{ :duration => 7, :percentage => 25 }, { :duration => 7, :percentage => 25 }, { :duration => 7, :percentage => 25 }, { :duration => 7, :percentage => 25 }, { :duration => 7, :percentage => 25 }, { :duration => 7, :percentage => 25 }, { :duration => 7, :percentage => 25 }, { :duration => 7, :percentage => 25 }])
  ProjectOption.create!(:description => '15-Month \\\"Long-Term Support\\\" Option', :active => false, :redemption_schedule => [{ :duration => 30, :percentage => 10}, { :duration => 30, :percentage => 10}, { :duration => 30, :percentage => 10}, { :duration => 30, :percentage => 10}, { :duration => 30, :percentage => 10}, { :duration => 30, :percentage => 10}, { :duration => 30, :percentage => 10}, { :duration => 30, :percentage => 10}, { :duration => 30, :percentage => 10}, { :duration => 30, :percentage => 10}, { :duration => 30, :percentage => 10}, { :duration => 30, :percentage => 10}, { :duration => 30, :percentage => 10}, { :duration => 30, :percentage => 10}, { :duration => 30, :percentage => 10}])
  ProjectOption.create!(:description => '4-Week Option (5-5-5-5)', :active => true, :redemption_schedule => [{ :duration => 7, :percentage => 50}, { :duration => 7, :percentage => 50}, { :duration => 7, :percentage => 50}, { :duration => 7, :percentage => 50}])
  ProjectOption.create!(:description => '3-Week Option (10-5-5)', :active => true, :redemption_schedule => [{ :duration => 7, :percentage => 100}, { :duration => 7, :percentage => 50 }, { :duration => 7, :percentage => 50 }])
  ProjectOption.create!(:description => '1-Time Option (pay 10-get 20)', :active => true, :redemption_schedule => [{ :duration => 90, :percentage => 200}])
  ProjectOption.create!(:description => '3-Month Option (150-30-20)-Lipstick', :active => true, :redemption_schedule => [{ :duration => 30, :percentage => 150}, { :duration => 30, :percentage => 30 }, { :duration => 30, :percentage => 20 }])
  ProjectOption.create!(:description => '2-Month Option (150-50)-New Zola', :active => true, :redemption_schedule => [{ :duration => 30, :percentage => 150}, { :duration => 30, :percentage => 50 }])

  lines[80].sub(/[^\(]+/,'').split('), (').each do |campaign_string|
    campaign_array = campaign_string.split(/('|null), /)
    business = Business.find_by_business_id(campaign_array[2].gsub(/[^\d]/,''))
    if business
      business = business.id
    else
      puts "cannot find business w business_id #{campaign_array[2]}"
      next
    end
    default_option = ProjectOption.find_by_description('3-Month Option (10-5-5)').id
    project = Project.new(:campaign_id => campaign_array[0].gsub(/[^\d]/,''), :business_id => business, :min_amount => campaign_array[4].gsub(/[^\d]/,''), :max_amount => campaign_array[6].gsub(/[^\d]/,''), :goal => campaign_array[8].gsub(/[^\d]/,''), :success_date => campaign_array[10].sub(/\'/,''), :expiration_date => campaign_array[12].sub(/\'/,''), :reason => campaign_array[16].sub(/\'/,'')[0..499], :active => campaign_array[20].sub(/\'/,''), :name => campaign_array[22].sub(/\'/,''), :project_option_id => default_option)
    if project.campaign_id == 59
      project.project_option = ProjectOption.all[5]
    elsif project.campaign_id == 66
      project.project_option = ProjectOption.all[8]
    elsif project.campaign_id == 67
      project.project_option = ProjectOption.all[9]
    elsif project.campaign_id == 68
      project.project_option = ProjectOption.all[10]
    elsif project.campaign_id == 69
      project.project_option = ProjectOption.all[10]
    elsif project.campaign_id == 73
      project.project_option = ProjectOption.all[12]
    end
    project.save! unless project.campaign_id == 49
  end

  lines[166].sub(/[^\(]+/,'').split('), (').each do |investment_string|
    investment_array = investment_string.split(/\', \'/)
    user = User.find_by_user_id(investment_array[1].gsub(/[^\d]/,''))
    if user
      user = user.id
    else
      puts "skipping user #{investment_array[1]}"
      next
    end
    project = Project.find_by_campaign_id(investment_array[2].gsub(/[^\d]/,''))
    if project
      project = project.id
    else
      puts "skipping #{investment_array[2]}"
      next
    end
    purchase = Purchase.new(:user_id => user, :project_id => project, :amount => investment_array[8].sub(/\'/,''))
    purchase.created_at = Time.at(investment_array[10].sub(/\'/,'').to_i)
    purchase.save!
  end

  lines[262].sub(/[^\(]+/,'').split('), (').each do |transaction_string|
    transaction_array = transaction_string.split(/('|null), /)
    user = User.find_by_user_id(user_array[2].gsub(/[^\d]/,'')).id
    project = Project.find_by_campaign_id(user_array[4].gsub(/[^\d]/,'')).id
    date = user_array[6].sub(/\'/,'')
    coupon = Coupon.where(['user_id = ? AND project_id = ? AND start_date <= ? AND expiration_date >= ?', user, project, date, date]).first
    coupon.update_attribute(:used, true)
  end

end
