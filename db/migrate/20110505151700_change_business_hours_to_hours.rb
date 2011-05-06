class ChangeBusinessHoursToHours < ActiveRecord::Migration
  def self.up
    rename_column :businesses, :business_hours, :hours
  end

  def self.down
    rename_column :businesses, :hours, :business_hours
  end
end
