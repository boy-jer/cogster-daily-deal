class UpdateRedemptions < ActiveRecord::Migration
  def self.up
    rename_column :redemptions, :user_id, :coupon_id
    remove_column :redemptions, :investment_id
  end

  def self.down
    rename_column :redemptions, :coupon_id, :user_id
    add_column :redemptions, :investment_id, :integer
  end
end
