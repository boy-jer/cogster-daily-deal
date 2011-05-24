class SetFeaturedDefaultToFalse < ActiveRecord::Migration
  def self.up
    change_column :businesses, :featured, :boolean, :default => false
  end

  def self.down
  end
end
