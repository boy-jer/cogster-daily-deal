class AssignDayToHours < ActiveRecord::Migration
  def self.up
    add_column :hours, :day, :integer
  end

  def self.down
    remove_column :hours, :day
  end
end
