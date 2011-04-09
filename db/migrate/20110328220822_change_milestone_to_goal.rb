class ChangeMilestoneToGoal < ActiveRecord::Migration
  def self.up
    rename_column :projects, :milestone, :goal
  end

  def self.down
    rename_column :projects, :goal, :milestone
  end
end
