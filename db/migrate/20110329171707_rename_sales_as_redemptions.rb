class RenameSalesAsRedemptions < ActiveRecord::Migration
  def self.up
    rename_table :sales, :redemptions
  end

  def self.down
    rename_table :redemptions, :sales
  end
end
