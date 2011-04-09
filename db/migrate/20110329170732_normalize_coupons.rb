class NormalizeCoupons < ActiveRecord::Migration
  def self.up
    remove_column :coupons, :user_id
    remove_column :coupons, :project_id
    add_column :coupons, :investment_id, :integer
  end

  def self.down
    add_column :coupons, :user_id, :integer
    add_column :coupons, :project_id, :integer
    remove_column :coupons, :investment_id
  end
end
