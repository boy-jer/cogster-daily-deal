class ChangeCampaignToProjectOption < ActiveRecord::Migration
  def self.up
    rename_table :campaigns, :project_options
    rename_column :projects, :campaign_id, :project_option_id
  end

  def self.down
    rename_table :project_options, :campaigns
    rename_column :projects, :project_option_id, :campaign_id
  end
end
