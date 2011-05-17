class RemoveStatusFromPurchase < ActiveRecord::Migration
  def self.up
    remove_column :purchases, :status
  end

  def self.down
    add_column :purchases, :status, :string
  end
end
