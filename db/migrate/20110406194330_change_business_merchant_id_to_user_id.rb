class ChangeBusinessMerchantIdToUserId < ActiveRecord::Migration
  def self.up
    rename_column :businesses, :merchant_id, :user_id
  end

  def self.down
    rename_column :businesses, :user_id, :merchant_id
  end
end
