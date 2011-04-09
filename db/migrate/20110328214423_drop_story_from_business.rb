class DropStoryFromBusiness < ActiveRecord::Migration
  def self.up
    remove_column :businesses, :story
  end

  def self.down
    add_column :businesses, :story, :string
  end
end
