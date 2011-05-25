class AddDefaultGoalToProject < ActiveRecord::Migration
  def self.up
    change_column :projects, :goal, :integer, :default => 0
  end

  def self.down
  end
end
