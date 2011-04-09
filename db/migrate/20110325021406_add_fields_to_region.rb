class AddFieldsToRegion < ActiveRecord::Migration
  def self.up
    add_column :regions, :handle, :string
    add_column :regions, :state, :string
    add_column :regions, :active, :boolean
    add_column :regions, :description, :string
  end

  def self.down
    remove_column :regions, :handle
    remove_column :regions, :state
    remove_column :regions, :active
    remove_column :regions, :description
  end
end
