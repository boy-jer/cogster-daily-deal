class ChangeCampaignReturnToRedemptionSchedule < ActiveRecord::Migration
  def self.up
    remove_column :campaigns, :return_length
    add_column :campaigns, :redemption_schedule, :string
  end

  def self.down
    remove_column :campaigns, :redemption_schedule
    add_column :campaigns, :return_length, :integer
  end
end
