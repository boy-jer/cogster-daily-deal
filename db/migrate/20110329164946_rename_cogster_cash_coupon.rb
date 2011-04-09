class RenameCogsterCashCoupon < ActiveRecord::Migration
  def self.up
    rename_table :cogster_cashes, :coupons
  end

  def self.down
    rename_table :coupons, :cogster_cashes
  end
end
