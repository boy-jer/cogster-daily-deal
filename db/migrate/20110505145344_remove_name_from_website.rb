class RemoveNameFromWebsite < ActiveRecord::Migration
  def self.up
    remove_column :websites, :name
  end

  def self.down
    add_column :websites, :name, :string
  end
end
