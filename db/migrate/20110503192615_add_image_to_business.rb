class AddImageToBusiness < ActiveRecord::Migration
  def self.up
    add_column :businesses, :image, :string
  end

  def self.down
    remove_column :businesses, :image
  end
end
