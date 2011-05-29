class SetDefaultImpactToZero < ActiveRecord::Migration
  def self.up
    change_column :communities, :impact, :integer, :default => 0
  end

  def self.down
  end
end
