class AddImpactToCommunities < ActiveRecord::Migration
  def self.up
    add_column :communities, :impact, :integer

    Community.includes(:businesses => :current_project).all.each do |com|
      impact = com.businesses.map(&:current_project).sum(&:funded) * 3
      com.update_attribute(:impact, impact)
    end

    change_column :projects, :max_amount, :integer
    change_column :purchases, :amount, :integer
    change_column :coupons, :amount, :integer

  end

  def self.down
  end
end
