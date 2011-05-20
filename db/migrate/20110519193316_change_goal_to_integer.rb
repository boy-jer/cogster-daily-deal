class ChangeGoalToInteger < ActiveRecord::Migration
  def self.up
    change_column :projects, :goal, :integer
  end

  def self.down
    change_column :projects, :goal, :decimal
  end
end
