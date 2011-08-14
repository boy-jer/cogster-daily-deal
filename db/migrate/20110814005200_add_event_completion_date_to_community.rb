class AddEventCompletionDateToCommunity < ActiveRecord::Migration
  def self.up
    add_column :communities, :event_completion_date, :date
  end

  def self.down
    remove_column :communities, :event_completion_date
  end
end
