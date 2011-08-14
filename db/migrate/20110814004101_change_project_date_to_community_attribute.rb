class ChangeProjectDateToCommunityAttribute < ActiveRecord::Migration
  def self.up
    remove_column :projects, :expiration_date
    add_column :communities, :event_start, :date
  end

  def self.down
    add_column :projects, :expiration_date, :date
    remove_column :communities, :event_start
  end
end
