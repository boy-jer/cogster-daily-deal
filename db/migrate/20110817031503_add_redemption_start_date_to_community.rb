class AddRedemptionStartDateToCommunity < ActiveRecord::Migration
  def self.up
    add_column :communities, :redemption_start, :date
  end

  def self.down
    remove_column :communities, :redemption_start
  end
end
