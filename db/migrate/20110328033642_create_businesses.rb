class CreateBusinesses < ActiveRecord::Migration
  def self.up
    rename_table :merchants, :businesses
    rename_column :websites, :merchant_id, :business_id
    remove_column :users, :community_id
  end

  def self.down
    rename_table :businesses, :merchants
    rename_column :websites, :business_id, :merchant_id
    add_column :users, :community_id, :integer
  end
end
