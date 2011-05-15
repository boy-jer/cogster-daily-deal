class ChangeIncentivesToKicker < ActiveRecord::Migration
  def self.up
    rename_column :projects, :incentives, :kicker
  end

  def self.down
    rename_column :projects, :kicker, :incentives
  end
end
