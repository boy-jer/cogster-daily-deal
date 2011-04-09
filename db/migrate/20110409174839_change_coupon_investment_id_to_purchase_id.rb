class ChangeCouponInvestmentIdToPurchaseId < ActiveRecord::Migration
  def self.up
    rename_column :coupons, :investment_id, :purchase_id  
  end

  def self.down
    rename_column :coupons, :purchase_id, :investment_id
  end
end
