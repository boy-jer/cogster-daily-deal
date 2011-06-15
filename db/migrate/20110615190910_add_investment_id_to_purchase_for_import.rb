class AddInvestmentIdToPurchaseForImport < ActiveRecord::Migration
  def self.up
    add_column :purchases, :investment_id, :integer
  end

  def self.down
    remove_column :purchases, :investment_id
  end
end
