class AddEarningsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :earnings, :integer, :default => 0
  end

  def self.down
    remove_column :users, :earnings
  end
end
