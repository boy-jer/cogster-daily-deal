class AddFundedToProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :funded, :integer, :default => 0
    Project.all.each do |p|
      p.update_attribute(:funded, p.purchases.sum(:amount))
    end
  end

  def self.down
    remove_column :projects, :funded
  end
end
