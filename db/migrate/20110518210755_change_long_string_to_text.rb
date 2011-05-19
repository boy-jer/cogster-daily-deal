class ChangeLongStringToText < ActiveRecord::Migration
  def self.up
    change_column :businesses, :description, :text
    change_column :projects, :reason, :text
  end

  def self.down
    change_column :businesses, :description, :string
    change_column :projects, :reason, :string
  end
end
