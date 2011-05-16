class RemoveRedemptions < ActiveRecord::Migration
  def self.up
    drop_table :redemptions
    remove_column :coupons, :remainder
    add_column :coupons, :used, :boolean
    remove_column :purchases, :expiration_date
    rename_column :coupons, :initial_amount, :amount
  end

  def self.down
    rename_column :coupons, :amount, :initial_amount
    add_column :purchases, :expiration_date, :date
    remove_column :coupons, :used
    add_column :coupons, :remainder, :float
    create_table :redemptions do |t|
      t.integer :coupon_id
      t.date :date
      t.decimal :amount
      t.string :note
      t.timestamps
    end
  end

end
