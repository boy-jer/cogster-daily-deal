class ChangeRegionToCommunity < ActiveRecord::Migration
  def self.up
    rename_table :regions, :communities
    rename_column :businesses, :region_id, :community_id
    rename_column :users, :region_id, :community_id
  end

  def self.down
    rename_table :communities, :regions
    rename_column :businesses, :community_id, :region_id
    rename_column :users, :community_id, :region_id
  end
end
