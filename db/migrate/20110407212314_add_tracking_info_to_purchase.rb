class AddTrackingInfoToPurchase < ActiveRecord::Migration
  def self.up
    add_column :purchases, :customer_ip, :string
    add_column :purchases, :status, :string
    add_column :purchases, :error_message, :string
  end

  def self.down
    remove_column :purchases, :customer_ip
    remove_column :purchases, :status
    remove_column :purchases, :error_message
  end
end
