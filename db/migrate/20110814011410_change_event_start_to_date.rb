class ChangeEventStartToDate < ActiveRecord::Migration
  def self.up
    rename_column :communities, :event_start, :event_start_date
  end

  def self.down
    rename_column :communities, :event_start_date, :event_start
  end
end
