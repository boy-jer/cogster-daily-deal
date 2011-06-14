class AddTempColumnsForImport < ActiveRecord::Migration
  def self.up
    add_column :businesses, :business_id, :integer
    add_column :users, :user_id, :integer
    add_column :communities, :community_id, :integer
    add_column :projects, :campaign_id, :integer
    add_column :addresses, :location_id, :integer
    add_column :project_options, :campaign_id, :integer
  end

  def self.down
    remove_column :businesses, :business_id
    remove_column :users, :user_id
    remove_column :communities, :community_id
    remove_column :projects, :campaign_id
    remove_column :addresses, :location_id
    #remove_column :project_options, :campaign_id
  end
end
