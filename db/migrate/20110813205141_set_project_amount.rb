class SetProjectAmount < ActiveRecord::Migration
  def self.up
    rename_column :projects, :min_amount, :amount
    remove_column :projects, :max_amount
  end

  def self.down
    rename_column :projects, :amount, :min_amount
    add_column :projects, :max_amount, :integer
  end
end
