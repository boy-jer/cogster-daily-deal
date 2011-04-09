class ChangeInvestmentsToPurchases < ActiveRecord::Migration
  def self.up
    rename_table :investments, :purchases
  end

  def self.down
    rename_table :purchases, :investments
  end
end
