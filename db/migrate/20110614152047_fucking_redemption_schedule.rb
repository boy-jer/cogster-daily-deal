class FuckingRedemptionSchedule < ActiveRecord::Migration
  def self.up
    change_column :project_options, :redemption_schedule, :text
  end

  def self.down
  end
end
