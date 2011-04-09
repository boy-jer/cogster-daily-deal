class RenameTransactionAsSale < ActiveRecord::Migration
  def self.up
    rename_table :transactions, :sales
  end

  def self.down
    rename_table :sales, :transactions
  end
end
