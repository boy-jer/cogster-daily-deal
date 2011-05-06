class HoursMustHaveOpenAndClose < ActiveRecord::Migration
  def self.up
    rename_column :hours, :hour, :open_hour
    rename_column :hours, :minute, :open_minute
    rename_column :hours, :meridian, :open_meridian
    add_column :hours, :close_hour, :integer
    add_column :hours, :close_minute, :integer
    add_column :hours, :close_meridian, :string
  end

  def self.down
    remove_column :hours, :close_hour
    remove_column :hours, :close_minute 
    remove_column :hours, :close_meridian
    rename_column :hours, :open_hour, :hour
    rename_column :hours, :open_minute, :minute
    rename_column :hours, :open_meridian, :meridian
  end
end
