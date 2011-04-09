class AddTypeToBusiness < ActiveRecord::Migration
  def self.up
    add_column :businesses, :type, :string
  end

  def self.down
    remove_column :businesses, :type
  end
end
