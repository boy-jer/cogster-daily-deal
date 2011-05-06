class RemoveHoursFromBusiness < ActiveRecord::Migration
  def self.up
    remove_column :businesses, :hours
  end

  def self.down
    add_column :businesses, :hours, :text
  end
end
