class RemoveOldTables < ActiveRecord::Migration
  def self.up
    remove_column :businesses, :type
    drop_table :deals   
    remove_column :projects, :kicker
  end

  def self.down
  end
end
