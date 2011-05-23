class AddClosedToHours < ActiveRecord::Migration
  def self.up
    add_column :hours, :closed, :boolean
  end

  def self.down
    remove_column :hours, :closed
  end
end
